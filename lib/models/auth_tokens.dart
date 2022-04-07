import 'package:flutter_appauth/flutter_appauth.dart';

class AuthTokens {
  final String? accessToken;
  final String? refreshToken;
  final String? idToken;
  final DateTime? accessTokenExpirationDateTime;

  const AuthTokens({
    this.accessToken,
    this.refreshToken,
    this.idToken,
    this.accessTokenExpirationDateTime,
  });

  factory AuthTokens.fromResponse(TokenResponse tokenResponse) => AuthTokens(
        accessToken: tokenResponse.accessToken,
        refreshToken: tokenResponse.refreshToken,
        idToken: tokenResponse.idToken,
        accessTokenExpirationDateTime:
            tokenResponse.accessTokenExpirationDateTime,
      );

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'idToken': idToken,
        'accessTokenExpirationDateTime':
            accessTokenExpirationDateTime?.toIso8601String()
      };

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    String? expiration = json['accessTokenExpirationDateTime'];

    return AuthTokens(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      idToken: json['idToken'],
      accessTokenExpirationDateTime:
          expiration == null ? null : DateTime.parse(expiration),
    );
  }
}
