import 'package:flutter/material.dart';
import 'screens/bottom_nav_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(); // ← .env 불러오기

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  print('db연결완료');

  runApp(const MegaPhoneApp());
}

class MegaPhoneApp extends StatelessWidget {
  const MegaPhoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'High Performance Megaphone',
      theme: ThemeData(fontFamily: 'Montserrat', primarySwatch: Colors.orange),
      home: const BottomNavScreen(),
    );
  }
}
