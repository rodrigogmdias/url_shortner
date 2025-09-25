import 'package:injectable/injectable.dart';
import 'package:network/network.dart';

@LazySingleton(as: NetworkEnvironment)
class NetworkEnvironmentImpl implements NetworkEnvironment {
  @override
  String get baseUrl => 'https://url-shortener-server.onrender.com';
}
