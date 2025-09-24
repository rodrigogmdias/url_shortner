import 'package:history/src/domain/models/short_url.dart';
import 'package:injectable/injectable.dart';
import 'package:storage/storage.dart';

abstract class HistoryRepository {
  Stream<List<ShortUrl>> watchAll();
}

@Injectable(as: HistoryRepository)
class HistoryRepositoryImpl implements HistoryRepository {
  final MemoryStorage _storage;

  HistoryRepositoryImpl(this._storage);

  @override
  Stream<List<ShortUrl>> watchAll() {
    return _storage.watchList<ShortUrl>(
      'shortened_urls',
      (json) => ShortUrl.fromJson(json as Map<String, dynamic>),
    );
  }
}
