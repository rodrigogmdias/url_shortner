import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

void main() {
  group('NetworkError.fromDioError', () {
    test('maps timeout types to NetworkTimeoutError', () {
      final options = RequestOptions(path: '/timeout');
      final timeoutTypes = [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ];

      for (final type in timeoutTypes) {
        final error = DioException(requestOptions: options, type: type);
        final mapped = NetworkError.fromDioError(error);
        expect(mapped, isA<NetworkTimeoutError>());
        expect(mapped.path, '/timeout');
        expect(mapped.message, 'Request timeout');
      }
    });

    test('maps badResponse to HttpStatusError with details', () {
      final options = RequestOptions(path: '/status');
      final response = Response<dynamic>(
        requestOptions: options,
        statusCode: 404,
        data: {'error': 'not found'},
      );
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: response,
      );

      final mapped = NetworkError.fromDioError(error);

      expect(mapped, isA<HttpStatusError>());
      final http = mapped as HttpStatusError;
      expect(http.path, '/status');
      expect(http.statusCode, 404);
      expect(http.body, {'error': 'not found'});
      expect(http.message, 'HTTP 404');
      expect(http.isClientError, isTrue);
      expect(http.isServerError, isFalse);
    });

    test('maps cancel to RequestCancelledError', () {
      final options = RequestOptions(path: '/cancel');
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.cancel,
      );

      final mapped = NetworkError.fromDioError(error);

      expect(mapped, isA<RequestCancelledError>());
      expect(mapped.path, '/cancel');
      expect(mapped.message, 'Request cancelled');
    });

    test(
      'maps unknown/badCertificate/connectionError to NetworkConnectionError',
      () {
        final options = RequestOptions(path: '/conn');
        final types = [
          DioExceptionType.unknown,
          DioExceptionType.badCertificate,
          DioExceptionType.connectionError,
        ];

        for (final type in types) {
          final error = DioException(
            requestOptions: options,
            type: type,
            message: 'no internet',
          );
          final mapped = NetworkError.fromDioError(error);
          expect(mapped, isA<NetworkConnectionError>());
          expect(mapped.path, '/conn');
          expect(mapped.message, 'no internet');
        }
      },
    );
  });

  group('NetworkError types', () {
    test('NetworkParsingError default and custom message', () {
      final def = NetworkParsingError('/parse');
      final custom = NetworkParsingError('/parse', message: 'invalid json');
      expect(def.message, 'Parsing error');
      expect(custom.message, 'invalid json');
    });

    test('HttpStatusError flags for client and server errors', () {
      final client = HttpStatusError(path: '/c', statusCode: 400);
      final server = HttpStatusError(path: '/s', statusCode: 500);
      final ok = HttpStatusError(path: '/o', statusCode: 200);
      expect(client.isClientError, isTrue);
      expect(client.isServerError, isFalse);
      expect(server.isClientError, isFalse);
      expect(server.isServerError, isTrue);
      expect(ok.isClientError, isFalse);
      expect(ok.isServerError, isFalse);
    });

    test('toString contains type, path and message', () {
      final err = NetworkTimeoutError('/t');
      final s = err.toString();
      expect(s, contains('NetworkTimeoutError'));
      expect(s, contains('path: /t'));
      expect(s, contains('message: Request timeout'));
    });
  });
}
