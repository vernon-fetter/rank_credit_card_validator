import 'package:flutter/material.dart';

import 'add_card_screen.dart';
import 'view_cards_screen.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Credit Card Validator')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'Add Card',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCardScreen()),
              ),
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'View Cards',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewCardsScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
