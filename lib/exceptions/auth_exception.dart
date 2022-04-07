import 'package:testapp/exceptions/application_exception.dart';

class AuthenticationException extends ApplicationException {
  const AuthenticationException({
    String message = 'An authentication error occurred',
    Object? inner,
  }) : super(message: message, inner: inner);

  factory AuthenticationException.onLogin({Object? error}) =>
      AuthenticationException(
        message: 'A login error occurred',
        inner: error,
      );

  factory AuthenticationException.onRefresh({Object? error}) =>
      AuthenticationException(
          message: 'A refresh error occurred', inner: error);

  factory AuthenticationException.onLogout({Object? error}) =>
      AuthenticationException(
          message: 'An error occurred during logout', inner: error);
}
