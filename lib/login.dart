import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock/providerUser.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _surnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Change your name:'),
            SizedBox(height: 20),
            TextField(
              controller: _surnameController,
              decoration: InputDecoration(
                hintText: 'Enter your surname',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Provider.of<UserData>(context, listen: false)
                    .setSurname(_surnameController.text);
                Provider.of<UserData>(context, listen: false).setBalance();
                _surnameController.clear();
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Provider.of<UserData>(context, listen: false).resetBalance();
                // Navigator.pop(context);
              },
              child: Text('Reset Balance'),
            ),
          ],
        ),
      ),
    );
  }
}
