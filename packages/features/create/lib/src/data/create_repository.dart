import 'package:create/src/data/create_endpoint.dart';
import 'package:create/src/data/models/create_response.dart';
import 'package:create/src/domain/models/short_url.dart';
import 'package:injectable/injectable.dart';
import 'package:network/network.dart';
import 'package:storage/storage.dart';

abstract class CreateRepository {
  Future<ShortUrl> create(String url);
}

@Injectable(as: CreateRepository)
class CreateRepositoryImpl implements CreateRepository {
  CreateRepositoryImpl(this._storage, this._networkService);

  final MemoryStorage _storage;
  final NetworkService _networkService;

  @override
  Future<ShortUrl> create(String url) async {
    try {
      final result = await _networkService.send(
        CreateEndpoint(url: url),
        decoder: (data) =>
            CreateResponse.fromJson(data as Map<String, dynamic>),
      );

      final model = ShortUrl.fromReponse(result.data);

      await _storage.addToList<ShortUrl>(
        'shortened_urls',
        model,
        toEncodable: (ShortUrl su) => su.toJson(),
      );

      return model;
    } on NetworkError catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
