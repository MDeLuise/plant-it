import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Cache {
  final CacheManager cacheManager;

  Cache({required this.cacheManager});

  Future<bool> exists(String key) async {
    return await cacheManager.getFileFromCache(key).then((r) => r != null);
  }

  Future<String> get(String key) async {
    final fileFromCache = await cacheManager.getFileFromCache(key);
    if (fileFromCache == null) {
      throw Exception("No key $key inside the cache");
    }
    return fileFromCache.file.readAsString();
  }

  Future<String?> getOrNull(String key) async {
    final fileFromCache = await cacheManager.getFileFromCache(key);
    if (fileFromCache == null) {
      return Future.value(null);
    }
    return fileFromCache.file.readAsString();
  }

  void set(String key, String value) {
    final Uint8List bytes = Uint8List.fromList(utf8.encode(value));
    cacheManager.putFile(key, bytes);
  }

  void remove(String key) {
    cacheManager.removeFile(key);
  }

  void removeAll() {
    cacheManager.emptyCache();
  }
}
