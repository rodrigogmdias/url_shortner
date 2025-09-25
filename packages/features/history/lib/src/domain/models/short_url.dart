class ShortUrl {
  final String originalUrl;
  final String alias;

  ShortUrl({required this.originalUrl, required this.alias});

  factory ShortUrl.fromJson(Map<String, dynamic> json) {
    return ShortUrl(
      originalUrl: json['originalUrl'] as String,
      alias: json['alias'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'originalUrl': originalUrl, 'alias': alias};
  }
}
