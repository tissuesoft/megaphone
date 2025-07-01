import 'package:flutter/material.dart';

class RegistarHeader extends StatelessWidget {
  const RegistarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.15 > 64 ? 64.0 : screenWidth * 0.15;
    final iconInnerSize = iconSize / 2;

    return Container(
      width: double.infinity,
      height: 256,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFF8A5E)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              size: iconInnerSize,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '프로필 설정',
            style: TextStyle(
              fontFamily: 'Noto Sans KR',
              fontSize: screenWidth * 0.05 > 20 ? 20 : screenWidth * 0.05,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '닉네임을 설정해주세요',
            style: TextStyle(
              fontFamily: 'Noto Sans KR',
              fontSize: screenWidth * 0.035 > 14 ? 14 : screenWidth * 0.035,
              fontWeight: FontWeight.w400,
              color: const Color.fromRGBO(255, 255, 255, 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
