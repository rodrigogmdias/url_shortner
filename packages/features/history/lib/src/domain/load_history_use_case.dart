import 'package:history/src/data/history_repository.dart';
import 'package:history/src/domain/models/short_url.dart';
import 'package:injectable/injectable.dart';

abstract class LoadHistoryUseCase {
  Stream<List<ShortUrl>> call();
}

@Injectable(as: LoadHistoryUseCase)
class LoadHistoryUseCaseImpl implements LoadHistoryUseCase {
  LoadHistoryUseCaseImpl(this._repository);

  final HistoryRepository _repository;

  @override
  Stream<List<ShortUrl>> call() {
    return _repository.watchAll().map((urls) => urls.reversed.toList());
  }
}
