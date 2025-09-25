import 'package:network/src/enums/content_encoding.dart';
import 'package:network/src/enums/http_method.dart';

abstract class Endpoint {
  String get path;
  HttpMethod get method;
  ContentEncoding get contentEncoding;
  Map<String, dynamic>? get queryParameters => null;
  Map<String, dynamic>? get bodyParameters => null;
  Map<String, String>? get headers => null;
}
