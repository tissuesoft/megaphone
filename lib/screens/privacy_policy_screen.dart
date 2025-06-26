import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    '개인정보 처리방침',
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
                  '여기에 개인정보 처리방침 내용을 작성하세요.\n\n'
                      '예시:\n'
                      '귀하의 개인정보는 안전하게 보호되며, 다음과 같은 방식으로 처리됩니다...\n\n'
                      '(개인정보 처리방침 내용 계속)',
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
