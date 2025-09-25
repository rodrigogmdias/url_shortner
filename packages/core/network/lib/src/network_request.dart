import 'package:network/src/enums/content_encoding.dart';
import 'package:network/src/enums/http_method.dart';

class NetworkRequest {
  const NetworkRequest({
    required this.path,
    required this.method,
    required this.contentEncoding,
    this.queryParameters,
    this.body,
    this.headers,
  });

  final String path;
  final HttpMethod method;
  final ContentEncoding contentEncoding;
  final Map<String, dynamic>? queryParameters;
  final Map<String, dynamic>? body;
  final Map<String, String>? headers;
}
