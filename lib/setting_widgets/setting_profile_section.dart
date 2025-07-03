import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:megaphone/screens/account_info_screen.dart';

class SettingProfileSection extends StatefulWidget {
  const SettingProfileSection({super.key});

  @override
  State<SettingProfileSection> createState() => _SettingProfileSectionState();
}

class _SettingProfileSectionState extends State<SettingProfileSection> {
  String? nickname;

  @override
  void initState() {
    super.initState();
    fetchNickname();
  }

  Future<void> fetchNickname() async {
    try {
      final kakaoUser = await UserApi.instance.me();
      final kakaoId = kakaoUser.id.toString();

      final userData = await Supabase.instance.client
          .from('Users')
          .select('user_nickname')
          .eq('kakao_id', kakaoId)
          .maybeSingle();

      if (userData != null && mounted) {
        setState(() {
          nickname = userData['user_nickname'];
        });
      }
    } catch (e) {
      print('❌ 닉네임 불러오기 실패: $e');
    }
  }

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

          // 프로필 요약 (닉네임)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Row(
              children: [
                const SizedBox(width: 0),
                Text(
                  nickname ?? '불러오는 중...',
                  style: const TextStyle(
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
            color: const Color(0xFFE0E0E0),
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
            color: const Color(0xFFE0E0E0),
          ),
        ],
      ),
    );
  }
}
