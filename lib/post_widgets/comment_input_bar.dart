import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class CommentInputBar extends StatefulWidget {
      final int boardId;
      final VoidCallback onSubmit;

      const CommentInputBar({
        super.key,
        required this.boardId,
        required this.onSubmit,
      });

      @override
      State<CommentInputBar> createState() => _CommentInputBarState();
    }

    class _CommentInputBarState extends State<CommentInputBar> {
    final TextEditingController _controller = TextEditingController();
    final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

    Future<bool> isKakaoLoggedIn() async {
    final accessToken = await _secureStorage.read(key: 'kakao_access_token');
    final refreshToken = await _secureStorage.read(key: 'kakao_refresh_token');
    return accessToken != null && refreshToken != null;
  }

  Future<void> _sendComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final supabase = Supabase.instance.client;

    if (await isKakaoLoggedIn() == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('카카오톡으로 로그인해주세요.')),
      );
      return;
    }

    String? kakaoId;
    try {
      final kakaoUser = await UserApi.instance.me();
      kakaoId = kakaoUser.id.toString();
    } catch (e) {
      print('❌ 카카오 사용자 정보 조회 실패: $e');
    }
    if (kakaoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('카카오 사용자 정보를 가져올 수 없습니다.')),
      );
      return;
    }

    // Supabase Users 테이블에서 user_id 조회
    final userData = await supabase
        .from('Users')
        .select('user_id')
        .eq('kakao_id', kakaoId)
        .maybeSingle();

    if (userData == null || userData['user_id'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사용자 정보가 없습니다.')),
      );
      return;
    }

    final userId = userData['user_id'];

    try {
      await supabase.from('Comment').insert({
        'comment': text,
        'board_id': widget.boardId,
        'user_id': userId,
        'likes': 0,
      });

      _controller.clear();
      widget.onSubmit(); // 댓글 새로고침
    } catch (e) {
      print('❌ 댓글 저장 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('댓글 저장 중 오류가 발생했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 12),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: 8),
                    hintText: '댓글을 입력하세요...',
                    hintStyle: TextStyle(
                      color: Color(0xFFADAEBC),
                      fontFamily: 'Roboto',
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 38,
              child: ElevatedButton(
                onPressed: _sendComment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text(
                  '전송',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
