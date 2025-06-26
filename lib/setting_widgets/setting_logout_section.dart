import 'package:flutter/material.dart';
import 'package:megaphone/setting_widgets/account_delete.dart'; // ✅ 다이얼로그 함수 임포트

class SettingLogoutSection extends StatelessWidget {
  const SettingLogoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.fromLTRB(screenWidth * 0.04, 32, screenWidth * 0.04, 20),
      child: Column(
        children: [
          // 로그아웃 버튼
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFEF4444), width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // 로그아웃 처리 예정
              },
              child: const Text(
                '로그아웃',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0xFFEF4444),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // 회원 탈퇴 텍스트
          GestureDetector(
            onTap: () {
              showWithdrawDialog(context); // ✅ 다이얼로그 호출
            },
            child: const Text(
              '회원 탈퇴',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
