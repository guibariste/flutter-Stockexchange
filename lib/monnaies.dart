import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stock/providerUser.dart';
import 'package:provider/provider.dart';

class Currency {
  final String symbol;
  final double rate;
  String name; // Nom de la monnaie

  Currency({
    required this.symbol,
    required this.rate,
    required this.name,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    var rate;
    if (json['rate'] is String) {
      rate = double.parse(json['rate']);
    } else {
      rate = json['rate'];
    }

    return Currency(
      symbol: json['symbol'],
      rate: rate,
      name: '',
    );
  }
}

class Portfolio extends StatefulWidget {
  @override
  _PortfolioState createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  double amount = 0;
  List<Currency> currencies = [];
  Map<String, int> boughtCurrencies = {}; // Pour stocker les monnaies achetées

  Future<void> fetchData() async {
    // final now = DateTime.now();
    // final oneWeekAgo = now.subtract(
    //     Duration(days: 7)); // Obtenir la date d'une semaine auparavant
    // final customTimestamp =
    //     oneWeekAgo.millisecondsSinceEpoch; // Obtenir le timestamp correspondant

    final response =
        await http.get(Uri.parse('http://localhost:5001/stocks_list'));

    if (response.statusCode == 200) {
      List<dynamic> symbol = jsonDecode(response.body);
      List<dynamic> symbolDataList = symbol.take(10).toList();
      for (dynamic symbolData in symbolDataList) {
        String name = symbolData;
        // final currencyRespons = await http.get(Uri.parse(
        //     'http://localhost:5001/exchange_rate/$symbolData?timestamp=$customTimestamp'));
        // print(currencyRespons.body);

        final currencyResponse = await http
            .get(Uri.parse('http://localhost:5001/exchange_rate/$symbolData'));
        if (currencyResponse.statusCode == 200) {
          final data = jsonDecode(currencyResponse.body);
          Currency currency = Currency.fromJson(data);
          currency.name = name;
          setState(() {
            currencies.add(currency);
          });
        } else {
          print('Failed to load currency for symbol $name');
        }
      }
    } else {
      print('Failed to fetch symbols');
    }
  }

  void sellCurrency(Currency currency, double amount) {
    if (Provider.of<UserData>(context, listen: false)
        .currencies
        .any((c) => c.nom == currency.name && c.montant >= amount)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmer vente'),
            content: Text(
              'Voulez-vous vendre $amount ${currency.name} pour ${amount * currency.rate} \$?',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<UserData>(context, listen: false)
                      .ajouteBalance(amount * currency.rate);
                  Provider.of<UserData>(context, listen: false)
                      .subCurrency(currency.name, amount);
                  setState(() {});

                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Afficher un message d'erreur à l'utilisateur
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text('Vous n\'avez pas assez d\'actions.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void buyCurrency(Currency currency, double amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer l\'achat'),
          content: Text(
              'Voulez-vous acheter $amount ${currency.name} pour ${amount * currency.rate}\$ ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  Provider.of<UserData>(context, listen: false)
                      .enleveBalance(amount * currency.rate);
                  Provider.of<UserData>(context, listen: false)
                      .addCurrency(currency.name, amount);
                });
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: currencies.length,
        itemBuilder: (context, index) {
          return ListTile(
            title:
                Text('${currencies[index].name} (${currencies[index].symbol})'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Taux: ${currencies[index].rate.toStringAsFixed(2)}'),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Montant',
                          isDense: true, // Réduit la hauteur du champ
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          amount = double.tryParse(value) ?? 0;
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        buyCurrency(currencies[index], amount);
                      },
                      child: Text('Buy'),
                    ),
                    SizedBox(width: 8), // Ajoute un espace entre les boutons
                    TextButton(
                      onPressed: () {
                        sellCurrency(currencies[index], amount);
                      },
                      child: Text('Sell'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
