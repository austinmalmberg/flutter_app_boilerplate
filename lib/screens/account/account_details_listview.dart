import 'package:flutter/material.dart';

class AccountDetailsListView extends StatelessWidget {
  final List<MapEntry<String, dynamic>> items;

  const AccountDetailsListView({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        MapEntry<String, dynamic> item = items[index];

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${item.key}: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(item.value),
          ],
        );
      },
    );
  }
}
