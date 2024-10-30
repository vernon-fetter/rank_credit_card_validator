import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/credit_card.dart';

class CreditCardProvider with ChangeNotifier {
  List<CreditCard> _cards = [];
  List<String> _bannedCountries = [
    'Russia',
    'Burma (Myanmar)',
    'Iran',
    'Sudan',
    'Syria',
    'North Korea'
  ]; // Default banned countries

  List<CreditCard> get cards => _cards;

  bool isBannedCountry(String country) {
    return _bannedCountries.contains(country);
  }

  void addBannedCountry(String country) {
    _bannedCountries.add(country);
    notifyListeners();
  }

  void removeBannedCountry(String country) {
    _bannedCountries.remove(country);
    notifyListeners();
  }

  void updateBannedCountries(List<String> countries) {
    _bannedCountries = countries;
    notifyListeners();
  }

  String detectCardType(String cardNumber) {
    if (cardNumber.startsWith('4')) return 'Visa';
    if (cardNumber.startsWith('5')) return 'MasterCard';
    if (cardNumber.startsWith('3')) return 'American Express';
    return 'Unknown';
  }

  bool isCardValid(String cardNumber) {
    return _luhnCheck(cardNumber);
  }

  bool _luhnCheck(String cardNumber) {
    int sum = 0;
    bool alternate = false;
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int n = int.parse(cardNumber[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) n -= 9;
      }
      sum += n;
      alternate = !alternate;
    }
    return sum % 10 == 0;
  }

  Future<void> saveCard(CreditCard card) async {
    if (isBannedCountry(card.issuingCountry)) {
      throw Exception('This country is banned from using credit cards.');
    }

    if (cards.any((c) => c.cardNumber == card.cardNumber)) {
      throw Exception('Duplicate card detected.');
    }

    _cards.add(card);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    List<String> savedCards =
        _cards.map((c) => json.encode(c.toJson())).toList();
    await prefs.setStringList('cards', savedCards);
  }

  Future<void> loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedCards = prefs.getStringList('cards') ?? [];
    _cards =
        savedCards.map((c) => CreditCard.fromJson(json.decode(c))).toList();
    notifyListeners();
  }

  // Add method to check if the card exists
  bool cardExists(String cardNumber) {
    return _cards.any((c) => c.cardNumber == cardNumber);
  }
}
