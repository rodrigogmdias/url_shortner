import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:network/network.dart';

abstract class DioProvider {
  Dio get dio;
}

@LazySingleton(as: DioProvider)
class DioProviderImpl implements DioProvider {
  DioProviderImpl(this.environment);

  final NetworkEnvironment environment;

  @override
  Dio get dio => Dio(
    BaseOptions(
      baseUrl: environment.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
    ),
  );
}
