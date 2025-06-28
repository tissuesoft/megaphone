import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/bottom_nav_screen.dart';   // 홈 화면
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env 파일 로딩
  await dotenv.load(fileName: 'assets/.env');

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primarySwatch: Colors.orange,
      ),
      home: const LoginScreen(), // ✅ 앱 시작 시 로그인 화면 먼저 보여줌
    );
  }
}
