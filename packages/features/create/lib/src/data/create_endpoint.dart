import 'package:network/network.dart';

class CreateEndpoint extends Endpoint {
  CreateEndpoint({required this.url});

  final String url;

  @override
  String get path => '/api/alias';

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  ContentEncoding get contentEncoding => ContentEncoding.json;

  @override
  Map<String, dynamic>? get bodyParameters => {'url': url};
}
