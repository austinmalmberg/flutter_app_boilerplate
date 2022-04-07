import 'package:testapp/exceptions/application_exception.dart';

class ApiException extends ApplicationException {
  final String service;

  const ApiException(
    this.service, {
    String message = 'An error occurred while attempting to access the API',
    Object? inner,
  }) : super(title: '$service Error', message: message, inner: inner);
}
