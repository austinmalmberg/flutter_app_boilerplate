import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/exceptions/application_exception.dart';
import 'package:testapp/models/application_user.dart';
import 'package:testapp/models/authentication_manager.dart';
import 'package:testapp/screens/account/account_details_listview.dart';
import 'package:testapp/screens/shared/login_button.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _loading = false;

  Future<T?> _manageLoadingForFuture<T>(
      BuildContext context, Future<T> Function() callback) async {
    setState(() {
      _loading = true;
    });

    T? result;

    try {
      result = await callback();
    } on ApplicationException catch (error) {
      error.showInSnackBar(context);
    } catch (e) {
      ApplicationException error = ApplicationException.unhandled(error: e);

      error.showInSnackBar(context);
    } finally {
      setState(() {
        _loading = false;
      });
    }

    return result;
  }

  Future<void> _handleLogin(AuthenticationManager auth) async {
    _manageLoadingForFuture(context, auth.login);
  }

  Future<void> _handleLogout(AuthenticationManager auth,
      {bool clearData = false}) async {
    _manageLoadingForFuture(
        context, () async => await auth.logout(clearData: clearData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : Consumer<AuthenticationManager>(builder: (context, auth, _) {
                ApplicationUser? user = auth.user;

                if (user == null) {
                  return const LoginWidget();
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Account details
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: AccountDetailsListView(items: [
                          MapEntry('ID', user.id),
                          MapEntry('Name', user.name),
                          MapEntry('Email', user.email),
                        ]),
                      ),
                    ),

                    // Logout button
                    ElevatedButton(
                      onPressed: () async => await _handleLogout(auth),
                      child: const Text('Logout'),
                    ),

                    // Clear data button
                    ElevatedButton(
                      onPressed: () async =>
                          await _handleLogout(auth, clearData: true),
                      child: const Text('Clear Data'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.red[700]),
                      ),
                    )
                  ],
                );
              }),
      ),
    );
  }
}

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.face),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: LoginButton(),
        ),
      ],
    );
  }
}
