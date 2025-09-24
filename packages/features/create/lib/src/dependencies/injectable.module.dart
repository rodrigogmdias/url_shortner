//@GeneratedMicroModule;CreatePackageModule;package:create/src/dependencies/injectable.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:create/src/data/create_repository.dart' as _i699;
import 'package:create/src/domain/create_user_case.dart' as _i851;
import 'package:create/src/presentation/cubit/create_cubit.dart' as _i198;
import 'package:injectable/injectable.dart' as _i526;
import 'package:storage/storage.dart' as _i431;

class CreatePackageModule extends _i526.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.factory<_i699.CreateRepository>(
      () => _i699.CreateRepositoryImpl(gh<_i431.MemoryStorage>()),
    );
    gh.factory<_i851.CreateUseCase>(
      () => _i851.RegisterUseCaseImpl(gh<_i699.CreateRepository>()),
    );
    gh.factory<_i198.CreateCubit>(
      () => _i198.CreateCubit(gh<_i851.CreateUseCase>()),
    );
  }
}
