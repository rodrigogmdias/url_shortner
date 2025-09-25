//@GeneratedMicroModule;HistoryPackageModule;package:history/src/dependencies/injectable.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:history/src/data/history_repository.dart' as _i628;
import 'package:history/src/domain/load_history_use_case.dart' as _i209;
import 'package:history/src/presentation/cubit/history_cubit.dart' as _i689;
import 'package:injectable/injectable.dart' as _i526;
import 'package:storage/storage.dart' as _i431;

class HistoryPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.factory<_i628.HistoryRepository>(
        () => _i628.HistoryRepositoryImpl(gh<_i431.MemoryStorage>()));
    gh.factory<_i209.LoadHistoryUseCase>(
        () => _i209.LoadHistoryUseCaseImpl(gh<_i628.HistoryRepository>()));
    gh.factory<_i689.HistoryCubit>(
        () => _i689.HistoryCubit(gh<_i209.LoadHistoryUseCase>()));
  }
}
