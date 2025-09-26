import 'package:create/src/data/create_repository.dart';
import 'package:create/src/domain/create_user_case.dart';
import 'package:create/src/domain/models/short_url.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<CreateRepository>()])
import 'create_use_case_test.mocks.dart';

void main() {
  late MockCreateRepository repository;
  late CreateUseCase useCase;

  setUp(() {
    repository = MockCreateRepository();
    useCase = RegisterUseCaseImpl(repository);
  });

  group('CreateUseCase.execute', () {
    test('returns ShortUrl from repository', () async {
      const url = 'https://example.com/abc';
      final expected = ShortUrl(originalUrl: url, alias: 'xyz');
      when(repository.create(url)).thenAnswer((_) async => expected);

      final result = await useCase.execute(url);

      expect(result.alias, expected.alias);
      expect(result.originalUrl, expected.originalUrl);
      verify(repository.create(url)).called(1);
    });

    test('propagates errors thrown by repository', () async {
      const url = 'https://example.com/err';
      when(repository.create(url)).thenThrow(Exception('boom'));

      expect(() => useCase.execute(url), throwsA(isA<Exception>()));
      verify(repository.create(url)).called(1);
    });
  });
}
