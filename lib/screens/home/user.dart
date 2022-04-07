import 'package:flutter/material.dart';
import 'package:testapp/models/application_user.dart';

class UserWidget extends StatelessWidget {
  final ApplicationUser user;

  const UserWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Logged in as ${user.name}'),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Make API call'),
        ),
      ],
    );
  }
}
