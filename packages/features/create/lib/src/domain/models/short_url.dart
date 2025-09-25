import 'package:create/src/data/models/create_response.dart';

class ShortUrl {
  final String originalUrl;
  final String alias;

  ShortUrl({required this.originalUrl, required this.alias});

  factory ShortUrl.fromReponse(CreateResponse response) {
    return ShortUrl(originalUrl: response.links.self, alias: response.alias);
  }

  Map<String, dynamic> toJson() {
    return {'originalUrl': originalUrl, 'alias': alias};
  }

  factory ShortUrl.fromJson(Map<String, dynamic> json) {
    return ShortUrl(originalUrl: json['originalUrl'], alias: json['alias']);
  }
}
