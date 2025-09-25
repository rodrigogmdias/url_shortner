import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';

@lazySingleton
class MemoryStorage {
  final Map<String, String> _storage = {};
  final StreamController<String> _changes =
      StreamController<String>.broadcast();

  Future<void> save(String key, String value) async {
    _storage[key] = value;
    _changes.add(key);
  }

  Stream<String?> watch(String key) async* {
    yield _storage[key];
    yield* _changes.stream
        .where((changedKey) => changedKey == key)
        .map((_) => _storage[key]);
  }

  Future<void> delete(String key) async {
    _storage.remove(key);
    _changes.add(key);
  }

  Future<List<String>> getAllKeys() async {
    return _storage.keys.toList();
  }

  Future<void> addToList<T>(
    String key,
    T value, {
    Object? Function(T value)? toEncodable,
  }) async {
    final encodable = toEncodable != null
        ? toEncodable(value)
        : value as Object?;

    final currentRaw = _storage[key];
    List<dynamic> list;
    if (currentRaw == null || currentRaw.isEmpty) {
      list = <dynamic>[];
    } else {
      try {
        final decoded = jsonDecode(currentRaw);
        if (decoded is List) {
          list = List<dynamic>.from(decoded);
        } else {
          list = <dynamic>[decoded];
        }
      } catch (_) {
        list = <dynamic>[];
      }
    }

    list.add(encodable);
    _storage[key] = jsonEncode(list);
    _changes.add(key);
  }

  Future<List<T>> getList<T>(
    String key,
    T Function(Object? json) fromJson,
  ) async {
    final currentRaw = _storage[key];
    if (currentRaw == null || currentRaw.isEmpty) return <T>[];
    try {
      final decoded = jsonDecode(currentRaw);
      if (decoded is List) {
        return decoded.map<T>((e) => fromJson(e)).toList();
      }
      return <T>[fromJson(decoded)];
    } catch (_) {
      return <T>[];
    }
  }

  Stream<List<T>> watchList<T>(
    String key,
    T Function(Object? json) fromJson,
  ) async* {
    yield await getList<T>(key, fromJson);
    yield* _changes.stream
        .where((changedKey) => changedKey == key)
        .asyncMap((_) => getList<T>(key, fromJson));
  }

  Future<void> clearList(String key) async {
    if (_storage.containsKey(key)) {
      _storage.remove(key);
      _changes.add(key);
    }
  }

  @disposeMethod
  void dispose() {
    _changes.close();
  }
}
