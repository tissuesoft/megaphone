import 'package:flutter/material.dart';
import 'screens/bottom_nav_screen.dart';

void main() {
  runApp(const MegaPhoneApp());
}

class MegaPhoneApp extends StatelessWidget {
  const MegaPhoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'High Performance Megaphone',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primarySwatch: Colors.orange,
      ),
      home: const BottomNavScreen(),
    );
  }
}
