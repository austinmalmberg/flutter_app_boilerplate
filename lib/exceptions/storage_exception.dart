import 'package:testapp/exceptions/application_exception.dart';

class StorageException extends ApplicationException {
  const StorageException({
    String message = 'An error occurred while accessing storage',
    Object? inner,
  }) : super(message: message, inner: inner);

  factory StorageException.onTokenDeleted({Object? error}) => StorageException(
        message: 'An error occurred while deleting the token',
        inner: error,
      );

  factory StorageException.onTokenSaved({Object? error}) => StorageException(
        message: 'An error occurred while saving the token',
        inner: error,
      );

  factory StorageException.onTokenLoaded({Object? error}) => StorageException(
        message: 'An error occurred while attempting to load the token',
        inner: error,
      );

  factory StorageException.onUserDeleted({Object? error}) => StorageException(
        message: 'An error occurred while deleting the user',
        inner: error,
      );

  factory StorageException.onUserSaved({Object? error}) => StorageException(
        message: 'An error occurred while saving the user',
        inner: error,
      );

  factory StorageException.onUserLoaded({Object? error}) => StorageException(
        message: 'An error occurred while attempting to load the user',
        inner: error,
      );

  factory StorageException.onCachedUserDeleted({Object? error}) =>
      StorageException(
        message: 'An error occurred while deleting the cached user',
        inner: error,
      );

  factory StorageException.onCachedUserSaved({Object? error}) =>
      StorageException(
        message: 'An error occurred while saving the cached user',
        inner: error,
      );
}
