//@GeneratedMicroModule;NetworkPackageModule;package:network/src/dependencies/injectable.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:injectable/injectable.dart' as _i526;
import 'package:network/network.dart' as _i372;
import 'package:network/src/dio_provider.dart' as _i246;
import 'package:network/src/environment.dart' as _i40;
import 'package:network/src/network_service.dart' as _i431;

class NetworkPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i246.DioProvider>(
        () => _i246.DioProviderImpl(gh<_i372.NetworkEnvironment>()));
    gh.lazySingleton<_i431.NetworkService>(() => _i431.NetworkServiceImpl(
          gh<_i40.NetworkEnvironment>(),
          gh<_i246.DioProvider>(),
        ));
  }
}
