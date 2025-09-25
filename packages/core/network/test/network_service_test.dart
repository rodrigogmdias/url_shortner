import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network/src/dio_provider.dart';
import 'package:network/src/endpoint.dart';
import 'package:network/src/enums/content_encoding.dart';
import 'package:network/src/enums/http_method.dart';
import 'package:network/src/environment.dart';
import 'package:network/src/network_error.dart';
import 'package:network/src/network_response.dart';
import 'package:network/src/network_service.dart';

@GenerateNiceMocks([MockSpec<DioProvider>(), MockSpec<Dio>()])
import 'network_service_test.mocks.dart';

class TestEnvironment implements NetworkEnvironment {
  @override
  String get baseUrl => 'https://api.example.com';
}

class TestEndpoint implements Endpoint {
  TestEndpoint({
    required this.path,
    this.method = HttpMethod.get,
    this.contentEncoding = ContentEncoding.json,
    this.queryParameters,
    this.bodyParameters,
    this.headers,
  });

  @override
  final String path;
  @override
  final HttpMethod method;
  @override
  final ContentEncoding contentEncoding;
  @override
  final Map<String, dynamic>? queryParameters;
  @override
  final Map<String, dynamic>? bodyParameters;
  @override
  final Map<String, String>? headers;
}

void main() {
  late MockDioProvider dioProvider;
  late MockDio dio;
  late NetworkService service;
  const path = '/v1/test';

  setUp(() {
    dioProvider = MockDioProvider();
    dio = MockDio();
    when(dioProvider.dio).thenReturn(dio);
    service = NetworkServiceImpl(TestEnvironment(), dioProvider);
  });

  group('NetworkService.send', () {
    test('returns NetworkResponse on success with default decoder', () async {
      final endpoint = TestEndpoint(
        path: path,
        method: HttpMethod.post,
        contentEncoding: ContentEncoding.json,
        bodyParameters: {'foo': 'bar'},
        queryParameters: {'q': '1'},
        headers: {'X-Api': 'abc'},
      );

      final response = Response<dynamic>(
        data: {'ok': true},
        statusCode: 200,
        headers: Headers.fromMap({
          'X-Token': ['t'],
        }),
        requestOptions: RequestOptions(path: path),
      );

      when(
        dio.request<dynamic>(
          path,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          cancelToken: anyNamed('cancelToken'),
        ),
      ).thenAnswer((_) async => response);

      final result = await service.send<Map<String, dynamic>>(endpoint);

      expect(result, isA<NetworkResponse<Map<String, dynamic>>>());
      expect(result.data, {'ok': true});
      expect(result.statusCode, 200);
      expect(result.isSuccess, isTrue);
      expect(result.original, same(response));

      final captured = verify(
        dio.request<dynamic>(
          path,
          data: captureAnyNamed('data'),
          queryParameters: captureAnyNamed('queryParameters'),
          options: captureAnyNamed('options'),
          cancelToken: captureAnyNamed('cancelToken'),
        ),
      ).captured;

      final data = captured[0];
      final query = captured[1] as Map<String, dynamic>;
      final options = captured[2] as Options;

      expect(data, endpoint.bodyParameters);
      expect(query, endpoint.queryParameters);
      expect(options.method, endpoint.method.name);
      expect(options.contentType, Headers.jsonContentType);
      expect(options.headers, containsPair('X-Api', 'abc'));
    });

    test('uses custom decoder when provided', () async {
      final endpoint = TestEndpoint(path: path, method: HttpMethod.get);

      final response = Response<dynamic>(
        data: {'value': '42'},
        statusCode: 200,
        headers: Headers.fromMap({}),
        requestOptions: RequestOptions(path: path),
      );

      when(
        dio.request<dynamic>(
          path,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          cancelToken: anyNamed('cancelToken'),
        ),
      ).thenAnswer((_) async => response);

      final result = await service.send<int>(
        endpoint,
        decoder: (data) => int.parse((data as Map)['value'] as String),
      );

      expect(result.data, 42);
    });

    test(
      'throws NetworkParsingError when casting fails without decoder',
      () async {
        final endpoint = TestEndpoint(path: path, method: HttpMethod.get);

        final response = Response<dynamic>(
          data: 'not a map',
          statusCode: 200,
          headers: Headers.fromMap({}),
          requestOptions: RequestOptions(path: path),
        );

        when(
          dio.request<dynamic>(
            path,
            data: anyNamed('data'),
            queryParameters: anyNamed('queryParameters'),
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).thenAnswer((_) async => response);

        expect(
          () => service.send<Map<String, dynamic>>(endpoint),
          throwsA(isA<NetworkParsingError>()),
        );
      },
    );

    test('maps DioException.badResponse to HttpStatusError', () async {
      final endpoint = TestEndpoint(path: path, method: HttpMethod.get);

      final dioError = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 404,
          data: {'error': 'not_found'},
          requestOptions: RequestOptions(path: path),
        ),
        requestOptions: RequestOptions(path: path),
      );

      when(
        dio.request<dynamic>(
          path,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          cancelToken: anyNamed('cancelToken'),
        ),
      ).thenThrow(dioError);

      expect(
        () => service.send<dynamic>(endpoint),
        throwsA(
          isA<HttpStatusError>()
              .having((e) => e.statusCode, 'statusCode', 404)
              .having((e) => e.body, 'body', {'error': 'not_found'})
              .having((e) => e.path, 'path', path),
        ),
      );
    });

    test('throws NetworkTimeoutError when send() timeout elapses', () async {
      final endpoint = TestEndpoint(path: path, method: HttpMethod.get);

      when(
        dio.request<dynamic>(
          path,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          cancelToken: anyNamed('cancelToken'),
        ),
      ).thenAnswer(
        (_) => Future<Response<dynamic>>.delayed(
          const Duration(milliseconds: 50),
          () => Response(
            data: {'ok': true},
            statusCode: 200,
            requestOptions: RequestOptions(path: path),
          ),
        ),
      );

      expect(
        () => service.send<dynamic>(
          endpoint,
          timeout: const Duration(milliseconds: 10),
        ),
        throwsA(isA<NetworkTimeoutError>()),
      );
    });

    test('maps DioException.cancel to RequestCancelledError', () async {
      final endpoint = TestEndpoint(path: path, method: HttpMethod.get);

      when(
        dio.request<dynamic>(
          path,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          cancelToken: anyNamed('cancelToken'),
        ),
      ).thenThrow(
        DioException(
          type: DioExceptionType.cancel,
          requestOptions: RequestOptions(path: path),
        ),
      );

      expect(
        () => service.send<dynamic>(endpoint),
        throwsA(isA<RequestCancelledError>()),
      );
    });

    test(
      'merges endpoint headers with extraHeaders and sets contentType',
      () async {
        final endpoint = TestEndpoint(
          path: path,
          method: HttpMethod.post,
          contentEncoding: ContentEncoding.json,
          bodyParameters: {'a': 1},
          headers: {'A': '1'},
        );

        when(
          dio.request<dynamic>(
            path,
            data: anyNamed('data'),
            queryParameters: anyNamed('queryParameters'),
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: <String, dynamic>{},
            statusCode: 200,
            headers: Headers.fromMap({}),
            requestOptions: RequestOptions(path: path),
          ),
        );

        await service.send<Map<String, dynamic>>(
          endpoint,
          extraHeaders: {'B': '2'},
        );

        final captured = verify(
          dio.request<dynamic>(
            path,
            data: captureAnyNamed('data'),
            queryParameters: anyNamed('queryParameters'),
            options: captureAnyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).captured;

        final data = captured[0];
        final options = captured[1] as Options;

        expect(options.headers, containsPair('A', '1'));
        expect(options.headers, containsPair('B', '2'));
        expect(options.contentType, Headers.jsonContentType);
        expect(data, endpoint.bodyParameters);
      },
    );

    test(
      'encodes body as FormData when ContentEncoding.formUrlEncoded',
      () async {
        final endpoint = TestEndpoint(
          path: path,
          method: HttpMethod.post,
          contentEncoding: ContentEncoding.formUrlEncoded,
          bodyParameters: {'x': 'y'},
        );

        when(
          dio.request<dynamic>(
            path,
            data: anyNamed('data'),
            queryParameters: anyNamed('queryParameters'),
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: <String, dynamic>{},
            statusCode: 200,
            headers: Headers.fromMap({}),
            requestOptions: RequestOptions(path: path),
          ),
        );

        await service.send<Map<String, dynamic>>(endpoint);

        final captured = verify(
          dio.request<dynamic>(
            path,
            data: captureAnyNamed('data'),
            queryParameters: anyNamed('queryParameters'),
            options: captureAnyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).captured;

        final data = captured[0];
        final options = captured[1] as Options;

        expect(data, isA<FormData>());
        expect(options.contentType, Headers.formUrlEncodedContentType);
      },
    );

    test('does not send body for GET requests', () async {
      final endpoint = TestEndpoint(
        path: path,
        method: HttpMethod.get,
        contentEncoding: ContentEncoding.json,
        bodyParameters: {'should': 'not be sent'},
      );

      when(
        dio.request<dynamic>(
          path,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          cancelToken: anyNamed('cancelToken'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: <String, dynamic>{},
          statusCode: 200,
          headers: Headers.fromMap({}),
          requestOptions: RequestOptions(path: path),
        ),
      );

      await service.send<Map<String, dynamic>>(endpoint);

      final data = verify(
        dio.request<dynamic>(
          path,
          data: captureAnyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          cancelToken: anyNamed('cancelToken'),
        ),
      ).captured[0];

      expect(data, isNull);
    });

    test(
      'passes raw body and null contentType when ContentEncoding.none',
      () async {
        final endpoint = TestEndpoint(
          path: path,
          method: HttpMethod.post,
          contentEncoding: ContentEncoding.none,
          bodyParameters: {'raw': 'value', 'n': 1},
        );

        when(
          dio.request<dynamic>(
            path,
            data: anyNamed('data'),
            queryParameters: anyNamed('queryParameters'),
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: <String, dynamic>{},
            statusCode: 200,
            headers: Headers.fromMap({}),
            requestOptions: RequestOptions(path: path),
          ),
        );

        await service.send<Map<String, dynamic>>(endpoint);

        final captured = verify(
          dio.request<dynamic>(
            path,
            data: captureAnyNamed('data'),
            queryParameters: anyNamed('queryParameters'),
            options: captureAnyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).captured;

        final data = captured[0] as Map<String, dynamic>;
        final options = captured[1] as Options;

        expect(data, endpoint.bodyParameters);
        expect(options.contentType, isNull);
      },
    );
  });
}
