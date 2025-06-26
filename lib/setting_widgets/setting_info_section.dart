import 'package:flutter/material.dart';
import '../screens/terms_of_use_screen.dart';
import '../screens/privacy_policy_screen.dart'; // ✅ 추가

class SettingInfoSection extends StatelessWidget {
  const SettingInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 정보 제목
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 16),
            child: const Text(
              '정보',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF333333),
              ),
            ),
          ),

          // 앱 정보
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.info_outline, size: 18, color: Color(0xFF333333)),
                    SizedBox(width: 12),
                    Text(
                      '앱 정보',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                const Text(
                  'v1.0.2',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 앱 정보 밑 Divider
          Container(
            width: double.infinity,
            height: 1,
            color: Color(0xFFEEEEEE),
          ),

          // 이용약관
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsOfUseScreen(),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.article_outlined, size: 18, color: Color(0xFF333333)),
                      SizedBox(width: 12),
                      Text(
                        '이용약관',
                        style: TextStyle(
                          fontFamily: 'Poppins',
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

          // 이용약관 밑 Divider
          Container(
            width: double.infinity,
            height: 1,
            color: Color(0xFFEEEEEE),
          ),

          // 개인정보 처리방침
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.lock_outline, size: 18, color: Color(0xFF333333)),
                      SizedBox(width: 12),
                      Text(
                        '개인정보 처리방침',
                        style: TextStyle(
                          fontFamily: 'Poppins',
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

          // 개인정보 처리방침 밑 Divider
          Container(
            width: double.infinity,
            height: 1,
            color: Color(0xFFEEEEEE),
          ),
        ],
      ),
    );
  }
}
