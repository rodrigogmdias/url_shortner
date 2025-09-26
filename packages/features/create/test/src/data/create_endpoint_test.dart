import 'package:create/src/data/create_endpoint.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

void main() {
  group('CreateEndpoint', () {
    test('exposes fixed path', () {
      final ep = CreateEndpoint(url: 'https://example.com');
      expect(ep.path, '/api/alias');
    });

    test('uses POST method', () {
      final ep = CreateEndpoint(url: 'x');
      expect(ep.method, HttpMethod.post);
    });

    test('uses JSON content encoding', () {
      final ep = CreateEndpoint(url: 'x');
      expect(ep.contentEncoding, ContentEncoding.json);
    });

    test('provides url in bodyParameters', () {
      const url = 'https://example.com/long/url';
      final ep = CreateEndpoint(url: url);
      expect(ep.bodyParameters, {'url': url});
    });

    test('optional parts default to null', () {
      final ep = CreateEndpoint(url: 'x');
      expect(ep.queryParameters, isNull);
      expect(ep.headers, isNull);
    });
  });
}
