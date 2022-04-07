import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/models/application_user.dart';
import 'package:testapp/models/authentication_manager.dart';
import 'package:testapp/routes.dart';
import 'package:testapp/screens/home/user.dart';
import 'package:testapp/screens/shared/login_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(Screens.account.route),
              icon: const Icon(Icons.person))
        ],
      ),
      body: Center(
        child: Consumer<ApplicationUser?>(builder: (context, user, _) {
          if (user != null) {
            return UserWidget(user: user);
          }

          return const LoginButton(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Get Started',
                style: TextStyle(fontSize: 36.0),
              ),
            ),
          );
        }),
      ),
    );
  }
}
