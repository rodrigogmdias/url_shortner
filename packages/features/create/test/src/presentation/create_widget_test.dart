import 'dart:async';

import 'package:create/src/domain/models/short_url.dart';
import 'package:create/src/presentation/create_widget.dart';
import 'package:create/src/presentation/cubit/create_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<CreateCubit>()])
import 'create_widget_test.mocks.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  late MockCreateCubit cubit;
  late StreamController<CreateState> controller;

  setUpAll(() {
    provideDummy<CreateState>(CreateInitial());
  });

  setUp(() {
    cubit = MockCreateCubit();
    controller = StreamController<CreateState>.broadcast();

    when(cubit.stream).thenAnswer((_) => controller.stream);
    when(cubit.state).thenReturn(CreateInitial());
    when(cubit.close()).thenAnswer((_) async => Future.value());

    GetIt.I.allowReassignment = true;
    GetIt.I.registerFactory<CreateCubit>(() => cubit);
  });

  tearDown(() async {
    await controller.close();
  });

  testWidgets('renders text field and button', (tester) async {
    await tester.pumpWidget(_wrap(const CreateWidget()));
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(OutlinedButton), findsOneWidget);
  });

  testWidgets('taps button calls cubit.create with current text', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const CreateWidget()));
    const url = 'https://example.com/x';
    await tester.enterText(find.byType(TextField), url);
    await tester.tap(find.byType(OutlinedButton));
    await tester.pumpAndSettle();
    verify(cubit.create(url)).called(1);
  });

  testWidgets('shows loading state while creating', (tester) async {
    await tester.pumpWidget(_wrap(const CreateWidget()));
    controller.add(CreateLoading());
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows success toast on CreateSuccess', (tester) async {
    await tester.pumpWidget(_wrap(const CreateWidget()));
    final model = ShortUrl(originalUrl: 'u', alias: 'a');
    controller.add(CreateSuccess(model));
    await tester.pumpAndSettle();
    expect(find.text('URL encurtada com sucesso!'), findsOneWidget);
  });

  testWidgets('shows error toast on CreateError', (tester) async {
    await tester.pumpWidget(_wrap(const CreateWidget()));
    controller.add(CreateError('custom error'));
    await tester.pump();
    expect(find.text('custom error'), findsOneWidget);
  });
}
