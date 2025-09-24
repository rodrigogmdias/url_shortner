import 'package:create/src/data/create_repository.dart';
import 'package:injectable/injectable.dart';

import 'models/short_url.dart';

abstract class CreateUseCase {
  Future<ShortUrl> execute(String url);
}

@Injectable(as: CreateUseCase)
class RegisterUseCaseImpl implements CreateUseCase {
  RegisterUseCaseImpl(this._createRepository);

  final CreateRepository _createRepository;

  @override
  Future<ShortUrl> execute(String url) async {
    return await _createRepository.create(url);
  }
}
