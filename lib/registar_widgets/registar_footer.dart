import 'package:flutter/material.dart';
import '../screens/bottom_nav_screen.dart';

class RegistarFooter extends StatelessWidget {
  final bool isNicknameAvailable;

  const RegistarFooter({super.key, required this.isNicknameAvailable});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final bool isActive = isNicknameAvailable;
    final Color buttonColor =
    isActive ? const Color(0xFFFF6B35) : const Color(0xFFD1D5DB);

    return Container(
      width: width,
      height: width * 0.35, // 반응형 높이 (예: 384px * 0.35 ≈ 134)
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
        width * 0.06, // 좌
        width * 0.06, // 상
        width * 0.06, // 우
        width * 0.04, // 하
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: isActive
                ? () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const BottomNavScreen(initialIndex: 0),
                ),
              );
            }
                : null,
            child: Container(
              width: double.infinity,
              height: width * 0.145, // 예: 56px
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(width * 0.03), // 예: 12px
              ),
              child: Center(
                child: Text(
                  '시작하기',
                  style: TextStyle(
                    fontFamily: 'Noto Sans KR',
                    fontSize: width * 0.042, // 예: 16px
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: width * 0.03), // 예: 12px
          Text(
            '나중에 프로필에서 변경할 수 있습니다',
            style: TextStyle(
              fontFamily: 'Noto Sans KR',
              fontSize: width * 0.031, // 예: 12px
              color: const Color(0xFF9CA3AF),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
