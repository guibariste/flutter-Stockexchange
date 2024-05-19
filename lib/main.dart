import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock/login.dart';
import 'package:stock/monnaies.dart';
import 'package:stock/providerUser.dart';
import 'package:stock/home.dart';
import 'package:stock/menu.dart';
import 'package:stock/appBar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NavigationProvider()..currentIndex = 0,
        ),
        ChangeNotifierProvider(
          create: (context) => UserData(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationProvider()..currentIndex = 0,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var navigationProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      appBar: const MyAppBar(),
      drawer: MenuWidget(),
      body: _getPage(navigationProvider.currentIndex),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return LoginPage();
      case 2:
        return Portfolio();
      case 3:
      default:
        return HomePage();
    }
  }
}
