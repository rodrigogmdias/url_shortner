import 'package:create/src/domain/models/short_url.dart';
import 'package:injectable/injectable.dart';
import 'package:storage/storage.dart';

abstract class CreateRepository {
  Future<ShortUrl> create(String url);
}

@Injectable(as: CreateRepository)
class CreateRepositoryImpl implements CreateRepository {
  CreateRepositoryImpl(this._storage);

  final MemoryStorage _storage;

  @override
  Future<ShortUrl> create(String url) async {
    final model = await Future.delayed(
      const Duration(seconds: 2),
      () => ShortUrl(originalUrl: url, shortUrl: 'https://short.url/abc123'),
    );

    await _storage.addToList<ShortUrl>(
      'shortened_urls',
      model,
      toEncodable: (ShortUrl su) => su.toJson(),
    );

    return model;
  }
}
