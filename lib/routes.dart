import 'package:flutter/material.dart';
import 'package:testapp/screens/account/main.dart';
import 'package:testapp/screens/home/main.dart';

enum Screens {
  home,
  account,
}

extension ScreenExtensions on Screens {
  String get route {
    switch (this) {
      case Screens.home:
        return '/';
      case Screens.account:
        return '/account';
    }
  }

  Widget Function(BuildContext) get screen {
    switch (this) {
      case Screens.home:
        return (context) => const HomeScreen(title: 'My Shiny New App');
      case Screens.account:
        return (context) => const AccountScreen();
    }
  }
}
