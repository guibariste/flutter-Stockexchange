import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}

class MenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void changePage(int index) {
      Provider.of<NavigationProvider>(context, listen: false).currentIndex =
          index;

      Navigator.of(context).pop(); // Ferme le drawer
    }

    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            child: Text('menu'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: const Text('Accueil'),
            onTap: () => changePage(0),
          ),
          ListTile(
            title: const Text('Connexion'),
            onTap: () => changePage(1),
          ),
          ListTile(
            title: const Text('monnaie'),
            onTap: () => changePage(2),
          ),
        ],
      ),
    );
  }
}
