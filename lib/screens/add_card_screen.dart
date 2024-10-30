import 'package:credit_card_validation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/credit_card_provider.dart';
import '../models/credit_card.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class AddCardScreen extends StatefulWidget {
  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  String? cardNumber;
  String? cvv;
  String? issuingCountry;

  Future<void> _scanCard() async {
    String scannedCardNumber = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', false, ScanMode.DEFAULT);
    if (scannedCardNumber != '-1') {
      setState(() {
        cardNumber = scannedCardNumber;
        final provider = Provider.of<CreditCardProvider>(context, listen: false);
        cvv = ''; // Reset CVV
        issuingCountry = ''; // Reset Issuing Country
      });
    }
  }

  void _submitCard() {
    if (_formKey.currentState?.validate() ?? false) {
      final provider = Provider.of<CreditCardProvider>(context, listen: false);
      final cardType = provider.detectCardType(cardNumber!);

      try {
        provider.saveCard(CreditCard(
          cardNumber: cardNumber!,
          cardType: cardType,
          cvv: cvv!,
          issuingCountry: issuingCountry!,
          dateAdded: DateTime.now(),
        ));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Card saved successfully')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Credit Card')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Card Number',
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value?.isEmpty ?? true)
                        return 'Enter a valid card number';
                      if (!Provider.of<CreditCardProvider>(context,
                              listen: false)
                          .isCardValid(value!)) return 'Invalid card number';
                      return null;
                    },
                    onChanged: (value) => cardNumber = value,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'CVV', border: OutlineInputBorder()),
                    validator: (value) =>
                        value?.isNotEmpty == true ? null : 'Enter CVV',
                    onChanged: (value) => cvv = value,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Issuing Country',
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (Provider.of<CreditCardProvider>(context,
                              listen: false)
                          .isBannedCountry(value!)) return 'Country is banned';
                      return value.isNotEmpty ? null : 'Enter issuing country';
                    },
                    onChanged: (value) => issuingCountry = value,
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: 'Scan Card',
                    onPressed: _scanCard,
                  ),
                  SizedBox(height: 30),
                  CustomButton(
                    text: 'Submit Card',
                    onPressed: _submitCard,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
