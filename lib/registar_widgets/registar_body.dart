import 'package:flutter/material.dart';

class RegistarBody extends StatefulWidget {
  final void Function(bool) onNicknameAvailableChanged;

  const RegistarBody({super.key, required this.onNicknameAvailableChanged});

  @override
  State<RegistarBody> createState() => _RegistarBodyState();
}

class _RegistarBodyState extends State<RegistarBody> {
  final TextEditingController _nicknameController = TextEditingController();
  int _nicknameLength = 0;

  String _nicknameStatus = '';
  final List<String> existingNicknames = ['admin', 'user1', '고확짱'];

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(() {
      setState(() {
        _nicknameLength = _nicknameController.text.length;
      });
    });
  }

  void _checkNicknameDuplicate() {
    final input = _nicknameController.text.trim();

    if (input.isEmpty) {
      setState(() {
        _nicknameStatus = '닉네임을 입력해주세요.';
      });
      widget.onNicknameAvailableChanged(false);
      return;
    }

    final isDuplicated = existingNicknames.contains(input);
    setState(() {
      _nicknameStatus =
      isDuplicated ? '이미 사용 중인 닉네임입니다.' : '사용 가능한 닉네임입니다!';
    });

    widget.onNicknameAvailableChanged(!isDuplicated);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final double iconSize = width * 0.085;
    final double profileSize = width * 0.25;
    final double profileBadgeSize = profileSize * 0.35;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          width * 0.06,
          32,
          width * 0.06,
          bottomInset + 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 닉네임 입력
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '닉네임',
                  style: TextStyle(
                    fontFamily: 'Noto Sans KR',
                    fontSize: width * 0.042,
                    color: const Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 12),
                Stack(
                  children: [
                    TextField(
                      controller: _nicknameController,
                      maxLength: 20,
                      style: TextStyle(
                        fontSize: width * 0.042,
                        fontFamily: 'Noto Sans KR',
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: '닉네임을 입력하세요',
                        hintStyle: TextStyle(
                          color: const Color(0xFFADAEBC),
                          fontFamily: 'Noto Sans KR',
                          fontSize: width * 0.042,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      top: 18,
                      child: GestureDetector(
                        onTap: _checkNicknameDuplicate,
                        child: Text(
                          '중복확인',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFFF6B35),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '영문, 숫자, 특수문자(_) 조합 4-20자',
                  style: TextStyle(
                    fontSize: width * 0.032,
                    color: const Color(0xFF9CA3AF),
                    fontFamily: 'Noto Sans KR',
                  ),
                ),
                const SizedBox(height: 4),
                if (_nicknameStatus.isNotEmpty)
                  Text(
                    _nicknameStatus,
                    style: TextStyle(
                      fontSize: width * 0.034,
                      color: _nicknameStatus.contains('가능') ? Colors.green : Colors.red,
                      fontFamily: 'Noto Sans KR',
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
