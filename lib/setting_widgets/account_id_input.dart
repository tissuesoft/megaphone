import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IdInputSection extends StatefulWidget {
  const IdInputSection({super.key});

  @override
  State<IdInputSection> createState() => _IdInputSectionState();
}

class _IdInputSectionState extends State<IdInputSection> {
  final TextEditingController _controller = TextEditingController();
  final supabase = Supabase.instance.client;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> updateNickname(String nickname) async {
    try {
      final kakaoUser = await UserApi.instance.me();
      final kakaoId = kakaoUser.id.toString();

      final response = await supabase
          .from('Users')
          .update({'user_nickname': nickname})
          .eq('kakao_id', kakaoId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('닉네임이 저장되었습니다.')),
        );
      }
    } catch (e) {
      print('❌ 닉네임 저장 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('닉네임 저장에 실패했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '닉네임',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            TextField(
              controller: _controller,
              maxLength: 20,
              decoration: InputDecoration(
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                hintText: '닉네임을 입력하세요',
                hintStyle: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontFamily: 'Poppins',
                  fontSize: 16,
                ),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 15,
              child: TextButton(
                onPressed: () {
                  String text = _controller.text.trim();
                  final regex = RegExp(r'^[\w가-힣]{2,20}$');
                  if (!regex.hasMatch(text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('닉네임은 한글, 영문, 숫자, _(언더스코어)만 사용하며 2~20자여야 합니다.')),
                    );
                  } else {
                    updateNickname(text);
                  }
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  minimumSize: const Size(52, 20),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  '저장',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFFFF6B35),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          '닉네임은 한글, 영문, 숫자, _(언더스코어)만 사용하며 2~20자여야 합니다.',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}
