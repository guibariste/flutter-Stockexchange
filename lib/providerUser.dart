import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserData extends ChangeNotifier {
  String _surname = '';
  double _balance = 0;
  List<Currency> _currencies = [];

  UserData() {
    loadUserData();
  }

  String get surname => _surname;
  double get balance => _balance;
  List<Currency> get currencies => _currencies;

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _surname = prefs.getString('surname') ?? '';
    _balance = prefs.getDouble('balance') ?? 10000000;
    // Charger les monnaies et leurs montants à partir des préférences partagées
    List<String>? currencyList = prefs.getStringList('currencies');
    if (currencyList != null) {
      _currencies = currencyList
          .map((currencyJson) => Currency.fromJson(jsonDecode(currencyJson)))
          .toList();
    }
    notifyListeners();
  }

  Future<void> setSurname(String surname) async {
    _surname = surname;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('surname', surname);
    notifyListeners();
  }

  Future<void> setBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('balance', 10000000);
    notifyListeners();
  }

  Future<void> addCurrency(String currencyName, double amount) async {
    // Vérifie si la monnaie est déjà dans la liste
    int index =
        _currencies.indexWhere((currency) => currency.nom == currencyName);
    if (index != -1) {
      // Si la monnaie est déjà dans la liste, ajoute le montant au montant existant
      _currencies[index].montant += amount;
    } else {
      // Sinon, crée un nouvel objet Currency pour cette monnaie
      _currencies.add(Currency(nom: currencyName, montant: amount));
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('currencies',
        _currencies.map((currency) => jsonEncode(currency.toJson())).toList());
    notifyListeners();
  }

  Future<void> subCurrency(String currencyName, double amount) async {
    // Vérifie si la monnaie est déjà dans la liste
    int index =
        _currencies.indexWhere((currency) => currency.nom == currencyName);
    if (index != -1) {
      // Vérifie si le montant à soustraire ne dépasse pas le montant possédé
      if (_currencies[index].montant >= amount) {
        // Soustrait le montant
        _currencies[index].montant -= amount;
      } else {
        // Affiche un message d'erreur ou lance une exception selon vos besoins
        throw Exception('Not enough currency to sell');
      }
    } else {
      // Sinon, crée un nouvel objet Currency pour cette monnaie
      _currencies.add(Currency(nom: currencyName, montant: -amount));
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('currencies',
        _currencies.map((currency) => jsonEncode(currency.toJson())).toList());
    notifyListeners();
  }

  void resetBalance() {
    _balance = 1000000.0;
    notifyListeners();
  }

  void enleveBalance(double montant) async {
    _balance -= montant;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('balance',
        _balance); // Mettre à jour la balance dans les préférences partagées
    notifyListeners();
  }

  void ajouteBalance(double montant) async {
    _balance += montant;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('balance',
        _balance); // Mettre à jour la balance dans les préférences partagées
    notifyListeners();
  }
}

class Currency {
  String nom; // Nom de la monnaie
  double montant; // Montant de la monnaie

  Currency({
    required this.nom,
    required this.montant,
  });

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'montant': montant,
    };
  }

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      nom: json['nom'],
      montant: json['montant'],
    );
  }
}
