import 'package:flutter/material.dart';

class OtherProfileScreen extends StatelessWidget {
  const OtherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상대 프로필'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 프로필 이미지
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/kimyongsik.jpg'), // 예시
            ),
            const SizedBox(height: 16),
            // 닉네임
            const Text(
              '고확왕',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '이곳은 상대방 프로필 디자인입니다.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text('여기에 stat, 탭, 게시글 등이 추가될 예정입니다.'),
          ],
        ),
      ),
    );
  }
}
