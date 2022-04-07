import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:testapp/db/token_repository.dart';
import 'package:testapp/db/cache_repository.dart';
import 'package:testapp/db/user_repository.dart';
import 'package:testapp/models/application_user.dart';
import 'package:testapp/models/auth_tokens.dart';

class ApplicationStorage {
  /* Flutter Secure Storage */
  final TokenRepository _tokenRepository = TokenRepository();

  /* Hive Storage */
  final UserRepository _userRepository = UserRepository();
  final CacheRepository _cacheRepository = CacheRepository();

  Future<void> initHive() async {
    debugPrint("[APPLICATION STORAGE] Initializing storage");

    await Hive.initFlutter();

    Hive.registerAdapter(ApplicationUserAdapter());

    await _userRepository.init();
    await _cacheRepository.init();
  }

  /*
   * BEGIN Token methods
  **/

  Future<void> saveTokens(String userId, AuthTokens tokens) async {
    await _tokenRepository.save(userId, tokens);
  }

  Future<AuthTokens?> loadTokens(String userId) async {
    return await _tokenRepository.load(userId);
  }

  Future<void> deleteTokens(String userId) async {
    await _tokenRepository.delete(userId);
  }
  /* END Token methods */

  /*
   * BEGIN ApplicationUser methods
  **/

  Future<void> saveUser(ApplicationUser user, {bool cacheUser = false}) async {
    await _userRepository.save(user);

    if (cacheUser) await _setCachedUser(user);
  }

  Future<ApplicationUser?> loadCachedUser() async {
    String? cachedUserId = _cacheRepository.getUserId();

    if (cachedUserId == null) {
      debugPrint("[APPLICATION STORAGE] No cached user found");

      return null;
    }

    debugPrint("[APPLICATION STORAGE] User found. Loading user: $cachedUserId");

    return _userRepository.getById(cachedUserId);
  }

  Future<void> _setCachedUser(ApplicationUser? user) async {
    await _cacheRepository.setCachedUser(user?.id);
  }

  Future<void> clearCachedUser() async {
    await _setCachedUser(null);
  }

  Future<void> deleteUser(ApplicationUser user) async {
    await _userRepository.delete(user);
  }

  Future<void> deleteUserById(String userId) async {
    await _userRepository.deleteById(userId);
  }
  /* END ApplicationUser methods */
}
