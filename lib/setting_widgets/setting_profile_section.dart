import 'package:flutter/material.dart';
import 'package:megaphone/screens/account_info_screen.dart';


class SettingProfileSection extends StatelessWidget {
  const SettingProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "계정" 텍스트
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 16),
            child: const Text(
              '계정',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF333333),
              ),
            ),
          ),

          // 프로필 요약 (이미지 + 이름)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(9999),
                  child: Image.asset(
                    'assets/kimyongsik.jpg',
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  '김고확',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Divider (프로필 아래)
          Container(
            width: double.infinity,
            height: 1,
            color: Color(0xFFE0E0E0),
          ),

          // 계정 정보 항목
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountInfoScreen(),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: 14,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.person_outline, size: 20, color: Color(0xFF333333)),
                      SizedBox(width: 12),
                      Text(
                        '계정 정보',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF333333)),
                ],
              ),
            ),
          ),

          // Divider (계정 정보 아래)
          Container(
            width: double.infinity,
            height: 1,
            color: Color(0xFFE0E0E0),
          ),
        ],
      ),
    );
  }
}
