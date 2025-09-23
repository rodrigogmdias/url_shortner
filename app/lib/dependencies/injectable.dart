import 'package:get_it/get_it.dart';
import 'package:home/home.dart';
import 'package:injectable/injectable.dart';
import 'package:router/router.dart';

import 'injectable.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  externalPackageModulesBefore: [
    ExternalModule(RouterPackageModule),
    ExternalModule(HomePackageModule),
  ],
)
void configureDependencies() => getIt.init();
