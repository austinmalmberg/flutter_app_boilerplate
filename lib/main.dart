import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/db/application_storage.dart';
import 'package:testapp/models/application_user.dart';
import 'package:testapp/models/authentication_manager.dart';
import 'package:testapp/providers/auth/microsoft.dart';
import 'package:testapp/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ApplicationStorage storage = ApplicationStorage();
  await storage.initHive();

  AuthenticationManager authenticationManager = AuthenticationManager(
    provider: Msal(),
    storage: storage,
  );
  await authenticationManager.loadCachedUser();

  runApp(MyApp(authenticationManager: authenticationManager));
}

class MyApp extends StatelessWidget {
  final AuthenticationManager authenticationManager;

  const MyApp({
    Key? key,
    required this.authenticationManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationManager>(
          create: (_) => authenticationManager,
        ),
        ProxyProvider<AuthenticationManager, ApplicationUser?>(
          update: (_, auth, __) => auth.user,
        ),
      ],
      child: MaterialApp(
        title: 'Provider Test',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: Screens.home.route,
        routes: {
          for (Screens screen in Screens.values) screen.route: screen.screen
        },
      ),
    );
  }
}
