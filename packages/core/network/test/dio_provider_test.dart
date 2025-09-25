import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network/src/dio_provider.dart';
import 'package:network/src/environment.dart';

import 'dio_provider_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NetworkEnvironment>()])
void main() {
  group('DioProviderImpl', () {
    late MockNetworkEnvironment env;
    late DioProviderImpl provider;

    setUp(() {
      env = MockNetworkEnvironment();
      when(env.baseUrl).thenReturn('https://api.example.com');
      provider = DioProviderImpl(env);
    });

    test('returns a Dio configured with expected BaseOptions', () {
      final dio = provider.dio;

      expect(dio, isA<Dio>());
      expect(dio.options.baseUrl, equals('https://api.example.com'));
      expect(dio.options.connectTimeout, equals(const Duration(seconds: 10)));
      expect(dio.options.receiveTimeout, equals(const Duration(seconds: 20)));
      expect(dio.options.sendTimeout, equals(const Duration(seconds: 20)));
    });

    test('creates a new Dio instance on each access', () {
      final first = provider.dio;
      final second = provider.dio;

      expect(identical(first, second), isFalse);
      expect(first, isNot(same(second)));
    });
  });
}
