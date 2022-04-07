import 'package:flutter/material.dart';
import 'package:testapp/db/repository_base.dart';
import 'package:testapp/exceptions/storage_exception.dart';

class CacheRepository extends HiveRepositoryBase<String> {
  static const String userKey = 'cachedUser';

  CacheRepository() : super(boxName: 'cache');

  Future<void> setCachedUser(String? userId) async {
    if (userId == null) {
      debugPrint("[CACHE REPOSITORY] Deleting cached user: $userId");

      return await delete();
    }

    await save(userId);
  }

  Future<void> save(String userId) async {
    debugPrint("[CACHE REPOSITORY] Saving user to cache, $userId");
    try {
      await box.put(userKey, userId);
    } catch (e) {
      StorageException.onCachedUserSaved(error: e);
    }
  }

  Future<void> delete() async {
    try {
      await box.delete(userKey);
    } catch (e) {
      StorageException.onCachedUserDeleted(error: e);
    }
  }

  String? getUserId() {
    return box.get(userKey);
  }
}
