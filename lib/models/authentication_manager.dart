import 'package:flutter/foundation.dart';
import 'package:testapp/db/application_storage.dart';
import 'package:testapp/exceptions/api_exception.dart';
import 'package:testapp/exceptions/application_exception.dart';
import 'package:testapp/exceptions/auth_exception.dart';
import 'package:testapp/models/application_user.dart';
import 'package:testapp/models/auth_tokens.dart';
import 'package:testapp/providers/api/microsoft_graph.dart';
import 'package:testapp/providers/auth/authentication_provider.dart';
import 'package:testapp/providers/auth/oauth.dart';
import 'package:testapp/providers/providers.dart';

/// Manages the [ApplicationUser] and [AuthTokens] within the context of the application.
class AuthenticationManager extends ChangeNotifier {
  late Oauth _oauth;
  late ApplicationStorage _storage;

  AuthTokens? _tokens;

  ApplicationUser? _user;
  ApplicationUser? get user => _user;

  AuthenticationManager({
    required AuthenticationProvider provider,
    required ApplicationStorage storage,
  }) {
    _oauth = Oauth(provider: provider);

    _storage = storage;
  }

  /// Attempts to return access token
  String? get accessToken => _tokens?.accessToken;

  Future<void> loadCachedUser({silent = true}) async {
    try {
      _user = await _storage.loadCachedUser();

      if (user != null) {
        _tokens = await _storage.loadTokens(user!.id);
      }
    } catch (e) {
      if (!silent) rethrow;
    }
  }

  Future<void> clearCachedUser() async {
    _storage.clearCachedUser();
  }

  /// Attempts to authenticate the user.
  ///
  /// Throws an [AuthenticationException] on login failure.
  /// Throws an [ApiException] if an error occurs in the attempt to get user info.
  /// Throws a [StorageException] if an error occurs in the attempt to get user info.
  Future<void> login() async {
    try {
      _tokens = await _oauth.login();
    } catch (e) {
      debugPrint(e.toString());

      throw AuthenticationException.onLogin(error: e);
    }

    if (_tokens != null) {
      ApplicationUser user = await _getUserInfo();

      await _storage.saveUser(user, cacheUser: true);

      await _storage.saveTokens(user.id, _tokens!);

      _user = user;

      notifyListeners();
    }
  }

  /// Attempts to refresh the access token. Prompts for
  /// reauthentication if login fails.
  ///
  /// Throws an [ArgumentError] if the refresh token is null.
  ///
  /// Throws an [AuthenticationException] if an error occurs.
  Future<void> refresh() async {
    if (_user == null) {
      throw ArgumentError.notNull('_user');
    } else if (_tokens == null) {
      throw ArgumentError.notNull('_tokens');
    } else if (_tokens!.refreshToken == null) {
      throw ArgumentError.notNull('_tokens.refreshToken');
    }

    String userId = user!.id;

    try {
      _tokens = await _oauth.refresh(_tokens!.refreshToken!);

      _storage.saveTokens(userId, _tokens!);

      debugPrint("[AUTHENTICATION] Token refresh successful for $userId");
    } catch (e) {
      // If an error occurs while the tokens are being refreshed,
      // clear the current tokens and have the user reauthenticate.

      debugPrint(
          "[AUTHENTICATION] Unable to refresh token for $userId, attempting reauthentication");

      _tokens = null;
      await _storage.deleteTokens(userId);

      await login();
    }
  }

  /// Logs out the user, while preserving user data.
  ///
  /// Use [clearAllUserData] to logout and delete all user data.
  Future<ApplicationException?> logout({bool clearData = false}) async {
    if (_user == null) {
      throw ArgumentError.notNull('_user');
    }

    String userId = user!.id;

    debugPrint(
        "[AUTHENTICATION] Logout intitiated for $userId (clearData: $clearData)");

    ApplicationException? error;

    if (clearData) {
      if (_tokens == null) {
        throw ArgumentError.notNull('_tokens');
      } else if (_tokens!.idToken == null) {
        throw ArgumentError.notNull('_tokens.idToken');
      }

      String idToken = _tokens!.idToken!;

      try {
        await _oauth.logout(idToken);
      } on ApplicationException catch (e) {
        error = e;
      }

      await _storage.deleteTokens(userId);
      _tokens = null;

      await _storage.deleteUserById(userId);
    }

    _user = null;

    // Prevent the user from being loaded on next login.
    await _storage.clearCachedUser();

    notifyListeners();

    return error;
  }

  Future<ApplicationUser> _getUserInfo() async {
    debugPrint("[AUTHENTICATION] Requesting user info");

    String? accessToken = _tokens?.accessToken;

    if (accessToken == null) {
      await login();
    }

    try {
      Map<String, dynamic> json = await getUserInfo(accessToken!);

      return ApplicationUser.fromJson(json);
    } on MicrosoftGraphException catch (e) {
      throw ApiException(
        Providers.microsoftGraph,
        message: 'Unable to get user details',
        inner: e,
      );
    }
  }

  /// True if the user has authenticated and false, otherwise.
  ///
  /// Being authenticated does not mean the access token is valid.
  bool get isAuthenticated => _tokens != null;

  /// Returns true if the access token is expired and false otherwise.
  ///
  /// This is done by comparing the token expiration time with the current system time and does not guarantee the token will be valid. If the system time is incorrect, this may return an erroneous result.
  ///
  /// Tokens may also become invalidated through the Authentication Provider.
  bool get isTokenExpired =>
      _tokens?.accessTokenExpirationDateTime?.isBefore(DateTime.now()) ?? true;
}
