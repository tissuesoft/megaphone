import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 여기에 흰색 배경 지정
      backgroundColor: Colors.white,

      // SafeArea로 시스템 영역 포함 흰색 처리
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Custom AppBar
            Container(
              height: 56,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Text(
                    '이용약관',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Color(0xFF333333),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF333333), size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 본문 스크롤 영역
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Text(
                  '여기에 이용약관 내용을 작성하세요.\n\n'
                      '예시:\n'
                      '본 서비스는 사용자에게 정보를 제공하며, 아래와 같은 조건에 따릅니다...\n\n'
                      '(이용약관 내용 계속)',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xFF333333),
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
