import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/credit_card_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CreditCardProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Credit Card Validator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo),
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.indigo[900]),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.grey[800]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
