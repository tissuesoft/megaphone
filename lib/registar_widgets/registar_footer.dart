import 'package:flutter/material.dart';
import '../screens/bottom_nav_screen.dart'; // ✅ 경로 맞춰주세요

class RegistarFooter extends StatelessWidget {
  final bool isNicknameAvailable;

  const RegistarFooter({super.key, required this.isNicknameAvailable});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isActive = isNicknameAvailable;
    final Color buttonColor =
    isActive ? const Color(0xFFFF6B35) : const Color(0xFFD1D5DB);

    return Container(
      width: screenWidth,
      height: 133,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 25, 24, 16),
      child: Column(
        children: [
          // 시작하기 버튼
          GestureDetector(
            onTap: isActive
                ? () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomNavScreen(initialIndex: 0),
                ),
              );
            }
                : null, // 비활성 상태일 땐 아무 것도 하지 않음
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  '시작하기',
                  style: TextStyle(
                    fontFamily: 'Noto Sans KR',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '나중에 프로필에서 변경할 수 있습니다',
            style: TextStyle(
              fontFamily: 'Noto Sans KR',
              fontSize: 12,
              color: Color(0xFF9CA3AF),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
