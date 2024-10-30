import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/credit_card_provider.dart';

class ViewCardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreditCardProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Saved Cards')),
      body: provider.cards.isEmpty
          ? Center(child: Text('No saved cards'))
          : ListView.builder(
              itemCount: provider.cards.length,
              itemBuilder: (_, index) {
                final card = provider.cards[index];
                return ListTile(
                  title: Text('${card.cardType} - ${card.cardNumber}'),
                  subtitle: Text('Country: ${card.issuingCountry}'),
                );
              },
            ),
    );
  }
}
