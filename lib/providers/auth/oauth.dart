import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:testapp/exceptions/application_exception.dart';
import 'package:testapp/exceptions/auth_exception.dart';
import 'package:testapp/models/auth_tokens.dart';
import 'package:testapp/providers/auth/authentication_provider.dart';

class Oauth {
  final FlutterAppAuth _auth = FlutterAppAuth();

  final AuthenticationProvider provider;

  late AuthorizationServiceConfiguration _serviceConfiguration;

  Oauth({required this.provider}) {
    _serviceConfiguration = AuthorizationServiceConfiguration(
      authorizationEndpoint: provider.authorizationEndpoint,
      tokenEndpoint: provider.tokenEndpoint,
    );
  }

  /// Attempts to authenticate the user.
  ///
  /// Throws and [AuthenticationException] on login failure.
  Future<AuthTokens?> login() async {
    AuthTokens? tokens;

    try {
      TokenResponse? tokenResponse =
          await _auth.authorizeAndExchangeCode(AuthorizationTokenRequest(
        provider.clientId,
        provider.platformRedirect,
        serviceConfiguration: _serviceConfiguration,
        discoveryUrl: provider.discoveryUrl,
        scopes: provider.scopes,
      ));

      if (tokenResponse != null) {
        tokens = AuthTokens.fromResponse(tokenResponse);
      }
    } catch (e) {
      throw AuthenticationException.onLogin(error: e);
    }

    return tokens;
  }

  /// Uses the [refreshToken] to get new [AuthTokens]
  Future<AuthTokens?> refresh(String refreshToken) async {
    AuthTokens? tokens;

    try {
      TokenRequest request = TokenRequest(
        provider.clientId,
        provider.platformRedirect,
        refreshToken: refreshToken,
        grantType: 'refresh_token',
      );

      TokenResponse? tokenResponse = await _auth.token(request);

      if (tokenResponse != null) {
        tokens = AuthTokens.fromResponse(tokenResponse);
      }
    } catch (e) {
      // Have the user reauthenticate if an error occurs while the tokens are being refreshed,
      tokens = await login();
    }

    return tokens;
  }

  /// Logs out the user.
  Future<void> logout(String idToken) async {
    try {
      await _auth.endSession(
        EndSessionRequest(
          idTokenHint: idToken,
          postLogoutRedirectUrl: provider.platformRedirect,
          discoveryUrl: provider.discoveryUrl,
        ),
      );
    } catch (e) {
      throw AuthenticationException.onLogout(error: e);
    }
  }
}
