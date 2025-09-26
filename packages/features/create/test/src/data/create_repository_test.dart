import 'package:create/src/data/create_repository.dart';
import 'package:create/src/data/models/create_response.dart';
import 'package:create/src/domain/models/short_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network/network.dart';
import 'package:storage/storage.dart';

@GenerateNiceMocks([MockSpec<NetworkService>(), MockSpec<MemoryStorage>()])
import 'create_repository_test.mocks.dart';

void main() {
  late MockNetworkService networkService;
  late MockMemoryStorage storage;
  late CreateRepository repository;

  setUp(() {
    networkService = MockNetworkService();
    storage = MockMemoryStorage();
    repository = CreateRepositoryImpl(storage, networkService);
  });

  group('CreateRepositoryImpl.create', () {
    test('deve criar ShortUrl e salvar no storage ao sucesso', () async {
      const originalUrl = 'https://example.com/some/long/url';
      const alias = 'abc123';
      const inputUrl = originalUrl;

      final responseModel = CreateResponse(
        alias: alias,
        links: Links(self: originalUrl, short: 'https://sho.rt/$alias'),
      );

      when(
        networkService.send<CreateResponse>(
          argThat(isA<Endpoint>()),
          decoder: anyNamed('decoder'),
          cancelToken: anyNamed('cancelToken'),
          extraHeaders: anyNamed('extraHeaders'),
          timeout: anyNamed('timeout'),
        ),
      ).thenAnswer((invocation) async {
        final decoder =
            invocation.namedArguments[#decoder]
                as CreateResponse Function(dynamic)?;
        final raw = {
          'alias': alias,
          '_links': {'self': originalUrl, 'short': 'https://sho.rt/$alias'},
        };
        final decoded = decoder != null ? decoder(raw) : responseModel;
        return NetworkResponse<CreateResponse>(
          data: decoded,
          statusCode: 201,
          headers: const <String, List<String>>{},
          original: Response(
            data: raw,
            statusCode: 201,
            requestOptions: RequestOptions(path: '/api/alias'),
          ),
        );
      });

      final result = await repository.create(inputUrl);

      expect(result, isA<ShortUrl>());
      expect(result.alias, alias);
      expect(result.originalUrl, originalUrl);

      verify(
        networkService.send<CreateResponse>(
          argThat(isA<Endpoint>().having((e) => e.path, 'path', '/api/alias')),
          decoder: anyNamed('decoder'),
          cancelToken: anyNamed('cancelToken'),
          extraHeaders: anyNamed('extraHeaders'),
          timeout: anyNamed('timeout'),
        ),
      );

      verify(
        storage.addToList<ShortUrl>(
          'shortened_urls',
          argThat(
            isA<ShortUrl>()
                .having((s) => s.alias, 'alias', alias)
                .having((s) => s.originalUrl, 'originalUrl', originalUrl),
          ),
          toEncodable: anyNamed('toEncodable'),
        ),
      ).called(1);
    });

    test(
      'deve lançar Exception com mensagem de erro de rede (NetworkError)',
      () async {
        const inputUrl = 'https://example.com';

        when(
          networkService.send<CreateResponse>(
            argThat(isA<Endpoint>()),
            decoder: anyNamed('decoder'),
            cancelToken: anyNamed('cancelToken'),
            extraHeaders: anyNamed('extraHeaders'),
            timeout: anyNamed('timeout'),
          ),
        ).thenThrow(NetworkTimeoutError('/api/alias'));

        expect(
          () => repository.create(inputUrl),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Network error:'),
            ),
          ),
        );

        verifyNever(
          storage.addToList<ShortUrl>(
            any,
            any,
            toEncodable: anyNamed('toEncodable'),
          ),
        );
      },
    );

    test('deve lançar Exception com mensagem de erro inesperado', () async {
      const inputUrl = 'https://example.com';

      when(
        networkService.send<CreateResponse>(
          argThat(isA<Endpoint>()),
          decoder: anyNamed('decoder'),
          cancelToken: anyNamed('cancelToken'),
          extraHeaders: anyNamed('extraHeaders'),
          timeout: anyNamed('timeout'),
        ),
      ).thenThrow(StateError('oops'));

      expect(
        () => repository.create(inputUrl),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Unexpected error:'),
          ),
        ),
      );

      verifyNever(
        storage.addToList<ShortUrl>(
          any,
          any,
          toEncodable: anyNamed('toEncodable'),
        ),
      );
    });
  });
}
