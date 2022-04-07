import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testapp/exceptions/storage_exception.dart';
import 'package:testapp/models/auth_tokens.dart';

class TokenRepository {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Saves the [AuthTokens] to device storage.
  ///
  /// Throws a [StorageException] if an error occurs.
  Future<void> save(String userId, AuthTokens tokens) async {
    debugPrint("[TOKEN REPOSITORY] Saving tokens for user id: $userId");

    try {
      await _storage.write(key: userId, value: jsonEncode(tokens));
    } catch (e) {
      throw StorageException.onTokenSaved(error: e);
    }
  }

  /// Load the [AuthTokens] from device storage.
  ///
  /// Throws a [StorageException] if an error occurs.
  Future<AuthTokens?> load(String userId) async {
    debugPrint("[TOKEN REPOSITORY] Loading tokens for user id: $userId");

    try {
      String? tokenString = await _storage.read(key: userId);

      if (tokenString == null) return null;

      Map<String, dynamic> json = jsonDecode(tokenString);

      return AuthTokens.fromJson(json);
    } catch (e) {
      throw StorageException.onTokenLoaded(error: e);
    }
  }

  /// Deletes the [AuthTokens] from storage.
  ///
  /// Throws a [StorageException] if an error occurs.
  Future<void> delete(String userId) async {
    debugPrint("[TOKEN REPOSITORY] Deleting tokens for user id: $userId");

    try {
      await _storage.delete(key: userId);
    } catch (e) {
      throw StorageException.onTokenDeleted(error: e);
    }
  }
}
