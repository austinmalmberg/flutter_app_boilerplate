import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/exceptions/application_exception.dart';
import 'package:testapp/models/authentication_manager.dart';

class LoginButton extends StatefulWidget {
  final Widget? child;
  final ButtonStyle? style;

  const LoginButton({
    Key? key,
    this.child,
    this.style,
  }) : super(key: key);

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const CircularProgressIndicator();
    }

    return Consumer<AuthenticationManager>(builder: (context, auth, _) {
      return ElevatedButton(
        onPressed: () async {
          setState(() {
            _loading = true;
          });

          try {
            await auth.login();
          } on ApplicationException catch (e) {
            e.showInSnackBar(context);
          } catch (e) {
            ApplicationException.unhandled(error: e).showInSnackBar(context);
          } finally {
            setState(() {
              _loading = false;
            });
          }
        },
        child: widget.child ?? const Text('Login'),
        style: widget.style,
      );
    });
  }
}
