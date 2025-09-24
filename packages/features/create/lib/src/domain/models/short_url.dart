class ShortUrl {
  final String originalUrl;
  final String shortUrl;

  ShortUrl({required this.originalUrl, required this.shortUrl});

  Map<String, dynamic> toJson() {
    return {'originalUrl': originalUrl, 'shortUrl': shortUrl};
  }
}
