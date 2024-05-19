import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock/providerUser.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('title'),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Consumer<UserData>(
              builder: (context, userData, child) {
                return Text(
                  'Balance: \$${userData.balance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
        ),
      ],
      backgroundColor: Colors.blue,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
