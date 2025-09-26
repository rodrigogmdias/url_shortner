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
}
