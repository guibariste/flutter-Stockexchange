// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock/providerUser.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<UserData>(
          builder: (context, userData, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                userData.surname.isNotEmpty
                    ? Column(
                        children: [
                          Text('Welcome, ${userData.surname}!'),
                          Text(
                              'Balance: \$${userData.balance.toStringAsFixed(2)}'),
                          // Display all currencies and their amounts
                          Column(
                            children: userData.currencies.map((currency) {
                              return ListTile(
                                title: Text(currency.nom),
                                subtitle: Text(
                                    'Nombre: ${currency.montant.toStringAsFixed(2)}'),
                              );
                            }).toList(),
                          ),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text('Create an Account'),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
