import 'package:injectable/injectable.dart';
import 'package:network/network.dart';

@LazySingleton(as: NetworkEnvironment)
class NetworkEnviroumentImpl implements NetworkEnvironment {
  @override
  String get baseUrl => 'https://url-shortener-server.onrender.com';
}
