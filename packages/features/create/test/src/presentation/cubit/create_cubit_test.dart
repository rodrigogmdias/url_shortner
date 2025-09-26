import 'package:create/src/domain/create_user_case.dart';
import 'package:create/src/domain/models/short_url.dart';
import 'package:create/src/presentation/cubit/create_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<CreateUseCase>()])
import 'create_cubit_test.mocks.dart';

void main() {
  late MockCreateUseCase useCase;
  late CreateCubit cubit;

  setUp(() {
    useCase = MockCreateUseCase();
    cubit = CreateCubit(useCase);
  });

  tearDown(() async {
    await cubit.close();
  });

  test('initial state is CreateInitial', () {
    expect(cubit.state, isA<CreateInitial>());
  });

  test('emits Loading then Success on create success', () async {
    const url = 'https://example.com/ok';
    final model = ShortUrl(originalUrl: url, alias: 'abc');
    when(useCase.execute(url)).thenAnswer((_) async => model);

    expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CreateLoading>(),
        isA<CreateSuccess>()
            .having((s) => s.shortenedUrl.alias, 'alias', 'abc')
            .having((s) => s.shortenedUrl.originalUrl, 'originalUrl', url),
      ]),
    );

    await cubit.create(url);
    verify(useCase.execute(url)).called(1);
  });

  test('emits Loading then Error on create failure', () async {
    const url = 'https://example.com/fail';
    when(useCase.execute(url)).thenThrow(Exception('boom'));

    expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CreateLoading>(),
        isA<CreateError>().having(
          (s) => s.message,
          'message',
          contains('boom'),
        ),
      ]),
    );

    await cubit.create(url);
    verify(useCase.execute(url)).called(1);
  });
}
