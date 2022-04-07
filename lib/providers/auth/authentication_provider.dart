import 'dart:io';

import 'package:flutter/foundation.dart';

abstract class AuthenticationProvider {
  final String clientId;
  final String tenantId;

  final String discoveryUrl;
  final String authorizationEndpoint;
  final String tokenEndpoint;

  final List<String> scopes;

  final RedirectUrls redirects;

  /// Returns the platform redirect for the current platform.
  String get platformRedirect {
    if (!kIsWeb) {
      if (Platform.isAndroid) return redirects.android;
      if (Platform.isIOS || Platform.isMacOS) return redirects.apple;
    }
    return redirects.web;
  }

  AuthenticationProvider({
    required this.clientId,
    required this.tenantId,
    required this.discoveryUrl,
    required this.authorizationEndpoint,
    required this.tokenEndpoint,
    required this.scopes,
    required this.redirects,
  });
}

class RedirectUrls {
  final String apple;
  final String android;
  final String web;

  RedirectUrls({
    required this.apple,
    required this.android,
    required this.web,
  });
}
