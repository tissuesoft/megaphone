import 'package:flutter/material.dart';
import 'screens/ranking_screen.dart';

void main() {
  runApp(const MegaphoneApp());
}

class MegaphoneApp extends StatelessWidget {
  const MegaphoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '고성능 확성기',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const RankingScreen(), // ✅ 처음에는 랭킹 화면으로 시작
      // routes: {
      //   '/profile': (context) => const ProfileScreen(), // ✅ 상대 프로필 라우트 추가
      // },
    );
  }
}
