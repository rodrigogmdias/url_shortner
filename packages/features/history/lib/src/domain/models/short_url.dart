class ShortUrl {
  final String originalUrl;
  final String shortUrl;

  ShortUrl({required this.originalUrl, required this.shortUrl});

  factory ShortUrl.fromJson(Map<String, dynamic> json) {
    return ShortUrl(
      originalUrl: json['originalUrl'] as String,
      shortUrl: json['shortUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'originalUrl': originalUrl, 'shortUrl': shortUrl};
  }
}
