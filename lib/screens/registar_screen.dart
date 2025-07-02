import 'package:flutter/material.dart';
import '../registar_widgets/registar_header.dart';
import '../registar_widgets/registar_body.dart';
import '../registar_widgets/registar_footer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'bottom_nav_screen.dart';


class RegistarScreen extends StatefulWidget {
  final String kakaoId;

  const RegistarScreen({super.key, required this.kakaoId});

  @override
  State<RegistarScreen> createState() => _RegistarScreenState();
}

class _RegistarScreenState extends State<RegistarScreen> {
  bool isNicknameAvailable = false;
  String nickname = '';

  void updateNicknameStatus(bool available) {
    setState(() {
      isNicknameAvailable = available;
    });
  }

  void updateNickname(String value) {
    nickname = value;
  }

  void submitRegistration() async {
    if (!isNicknameAvailable || nickname.isEmpty) return;

    final supabase = Supabase.instance.client;
    try {
      await supabase.from('Users').insert({
        'kakao_id': widget.kakaoId,
        'user_nickname': nickname,
      });

      // 회원가입 완료 후 바로 로그인 상태로 홈으로 이동
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const BottomNavScreen(initialIndex: 0),
          ),
        );
      }
    } catch (e) {
      print('❌ 회원가입 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF6B35),
      body: SafeArea(
        child: Column(
          children: [
            const RegistarHeader(),
            Expanded(
              child: RegistarBody(
                onNicknameAvailableChanged: updateNicknameStatus,
                onNicknameChanged: updateNickname,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: RegistarFooter(
        isNicknameAvailable: isNicknameAvailable,
        onSubmit: submitRegistration,
      ),
    );
  }
}
