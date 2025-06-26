import 'package:flutter/material.dart';

class IdInputSection extends StatefulWidget {
  const IdInputSection({super.key});

  @override
  State<IdInputSection> createState() => _IdInputSectionState();
}

class _IdInputSectionState extends State<IdInputSection> {
  final TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '아이디',
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
              maxLength: 20, // 최대 20자
              decoration: InputDecoration(
                counterText: '', // 하단 글자 수 숨기기
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                hintText: '아이디를 입력하세요',
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
                  if (text.length < 4) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('아이디는 최소 4자 이상이어야 합니다.')),
                    );
                  } else {
                    // TODO: 중복확인 로직
                  }
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  minimumSize: const Size(52, 20),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  '중복확인',
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
          '영문, 숫자, 특수문자(_), 한글 포함 4-20자',
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
