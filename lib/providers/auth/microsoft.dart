import 'package:testapp/providers/auth/authentication_provider.dart';

class Msal extends AuthenticationProvider {
  static const String _authority = 'https://login.microsoftonline.com/common';

  Msal()
      : super(
          discoveryUrl: '$_authority/v2.0/.well-known/openid-configuration',
          authorizationEndpoint: '$_authority/oauth2/v2.0/authorize',
          tokenEndpoint: '$_authority/oauth2/v2.0/token',
          clientId: 'cbfec50e-1d0f-4a4e-a003-a0b2c113654a',
          tenantId: '84edfe22-03c7-4fca-8140-980a9e3b3166',
          scopes: ['openid', 'email', 'User.Read', 'offline_access'],
          redirects: RedirectUrls(
            apple: 'com.malmberg.austin://oauthredirect/',
            android: 'com.malmberg.austin://oauthredirect',
            web: 'com.malmberg.austin://oauthredirect',
          ),
        );
}
