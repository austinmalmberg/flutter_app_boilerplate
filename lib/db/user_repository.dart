import 'package:flutter/material.dart';
import 'package:testapp/db/repository_base.dart';
import 'package:testapp/exceptions/storage_exception.dart';
import 'package:testapp/models/application_user.dart';

class UserRepository extends HiveRepositoryBase<ApplicationUser> {
  String cacheKey = 'cachedUser';

  UserRepository() : super(boxName: 'user');

  /// Saves an [ApplicationUser] to local storage.
  Future<void> save(ApplicationUser user) async {
    debugPrint("[USER REPOSITORY] Saving user: ${user.id}");

    try {
      await box.put(user.id, user);
    } catch (e) {
      throw StorageException.onUserSaved(error: e);
    }
  }

  ApplicationUser? getById(String userId) {
    return box.get(userId);
  }

  /// Deletes an [ApplicationUser] from local storage by their user ID.
  Future<void> deleteById(String userId) async {
    debugPrint("[USER REPOSITORY] Deleting user with id: $userId");

    try {
      await box.delete(userId);
    } catch (e) {
      throw StorageException.onUserDeleted(error: e);
    }
  }

  /// Deletes an [ApplicationUser] from local storage.
  Future<void> delete(ApplicationUser user) async {
    await deleteById(user.id);
  }

  /// Deletes all [ApplicationUser]s from local storage.
  Future<void> deleteAll() async {
    debugPrint("[USER REPOSITORY] Deleting all users");

    try {
      await box.clear();
    } catch (e) {
      throw StorageException.onUserDeleted(error: e);
    }
  }
}
