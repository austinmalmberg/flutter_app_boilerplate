import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ApplicationException implements Exception {
  final String message;
  final String? title;
  final Object? inner;

  const ApplicationException({
    this.title,
    this.message = 'An application error occurred',
    this.inner,
  });

  /// Clears any current [SnackBar]s then shows the error message.
  void showInSnackBar(BuildContext context) {
    SnackBar snackbar = SnackBar(
      content: _buildErrorCard(),
    );

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackbar);
  }

  factory ApplicationException.unhandled({Object? error}) =>
      ApplicationException(
        title: 'Unhandled Exception',
        message:
            'An unhandled exception occurred during login. Please contact the app administrator if the problem persists.',
        inner: error,
      );

  Widget _buildErrorCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (title != null)
          Text(
            title!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        Text(message),
        if (kDebugMode && inner != null)
          Wrap(
            children: [
              const Text(
                'DEBUG: ',
                style: TextStyle(color: Colors.red),
              ),
              Text(inner.toString()),
            ],
          )
      ],
    );
  }
}
