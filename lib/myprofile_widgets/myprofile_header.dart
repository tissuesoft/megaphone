import 'package:flutter/material.dart';
import 'package:megaphone/screens/setting_screen.dart'; // ✅ 설정 화면 import 추가

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      bottom: false,
      child: Container(
        height: 69,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Text(
              '내 프로필',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
                fontFamily: 'Montserrat',
              ),
            ),
            Positioned(
              right: screenWidth * 0.04,
              top: (69 - 44) / 2,
              child: SizedBox(
                width: 34,
                height: 44,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.settings,
                    size: 18,
                    color: Color(0xFF4B5563),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
