import 'package:home/src/presentation/home_page.dart';
import 'package:router/router.dart';

List<AppRoute> get homeRoutes => [
  AppRoute(path: '/', builder: (context, state) => const HomePage()),
];
