import 'package:create/create.dart';
import 'package:get_it/get_it.dart';
import 'package:history/history.dart';
import 'package:home/home.dart';
import 'package:injectable/injectable.dart';
import 'package:router/router.dart';
import 'package:storage/storage.dart';

import 'injectable.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  externalPackageModulesBefore: [
    ExternalModule(RouterPackageModule),
    ExternalModule(StoragePackageModule),
    ExternalModule(CreatePackageModule),
    ExternalModule(HistoryPackageModule),
    ExternalModule(HomePackageModule),
  ],
)
void configureDependencies() => getIt.init();
