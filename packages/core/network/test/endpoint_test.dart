import 'package:flutter_test/flutter_test.dart';
import 'package:network/src/endpoint.dart';
import 'package:network/src/enums/content_encoding.dart';
import 'package:network/src/enums/http_method.dart';

class TestEndpointDefault extends Endpoint {
  TestEndpointDefault({
    required String path,
    required HttpMethod method,
    required ContentEncoding encoding,
  }) : _path = path,
       _method = method,
       _encoding = encoding;

  final String _path;
  final HttpMethod _method;
  final ContentEncoding _encoding;

  @override
  String get path => _path;

  @override
  HttpMethod get method => _method;

  @override
  ContentEncoding get contentEncoding => _encoding;
}

class TestEndpointCustom extends Endpoint {
  TestEndpointCustom({
    required String path,
    required HttpMethod method,
    required ContentEncoding encoding,
    Map<String, dynamic>? query,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) : _path = path,
       _method = method,
       _encoding = encoding,
       _query = query,
       _body = body,
       _headers = headers;

  final String _path;
  final HttpMethod _method;
  final ContentEncoding _encoding;
  final Map<String, dynamic>? _query;
  final Map<String, dynamic>? _body;
  final Map<String, String>? _headers;

  @override
  String get path => _path;

  @override
  HttpMethod get method => _method;

  @override
  ContentEncoding get contentEncoding => _encoding;

  @override
  Map<String, dynamic>? get queryParameters => _query;

  @override
  Map<String, dynamic>? get bodyParameters => _body;

  @override
  Map<String, String>? get headers => _headers;
}

void main() {
  group('Endpoint', () {
    test('provides null for optional properties by default', () {
      final endpoint = TestEndpointDefault(
        path: '/v1/items',
        method: HttpMethod.get,
        encoding: ContentEncoding.json,
      );

      expect(endpoint.path, '/v1/items');
      expect(endpoint.method, HttpMethod.get);
      expect(endpoint.contentEncoding, ContentEncoding.json);
      expect(endpoint.queryParameters, isNull);
      expect(endpoint.bodyParameters, isNull);
      expect(endpoint.headers, isNull);
    });

    test('returns overridden optional properties when provided', () {
      final endpoint = TestEndpointCustom(
        path: '/v1/items',
        method: HttpMethod.post,
        encoding: ContentEncoding.formUrlEncoded,
        query: {'q': 'search', 'page': 2},
        body: {'name': 'item', 'active': true},
        headers: {'X-Trace-Id': 'abc-123'},
      );

      expect(endpoint.path, '/v1/items');
      expect(endpoint.method, HttpMethod.post);
      expect(endpoint.contentEncoding, ContentEncoding.formUrlEncoded);
      expect(endpoint.queryParameters, {'q': 'search', 'page': 2});
      expect(endpoint.bodyParameters, {'name': 'item', 'active': true});
      expect(endpoint.headers, {'X-Trace-Id': 'abc-123'});
    });
  });
}
