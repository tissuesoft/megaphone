import 'package:flutter/material.dart';
import 'screens/bottomNavScreen.dart'; // ✅ 추가

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'High Performance Megaphone',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primarySwatch: Colors.orange,
      ),
      home: const BottomNavScreen(), // ✅ 바뀐 부분
    );
  }
}
