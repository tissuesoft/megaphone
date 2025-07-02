import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../write_post_widgets/write_post_header.dart';
import '../write_post_widgets/time_slot_selector.dart';
import '../write_post_widgets/post_content_input.dart';
import '../write_post_widgets/tip_box.dart';
import '../write_post_widgets/write_button.dart';

class WritePostScreen extends StatefulWidget {
  const WritePostScreen({super.key});

  @override
  State<WritePostScreen> createState() => _WritePostScreenState();
}

Future<bool> isKakaoLoggedIn() async {
  final storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'kakao_access_token');
  final refreshToken = await storage.read(key: 'kakao_refresh_token');
  return accessToken != null && refreshToken != null;
}

class _WritePostScreenState extends State<WritePostScreen> {
  bool isContentNotEmpty = false;
  String content = '';
  DateTime? selectedTime;
  bool isLoading = false;

  void onContentChanged(String value) {
    setState(() {
      content = value;
      isContentNotEmpty = value.trim().isNotEmpty;
    });
  }

  void onTimeSelected(DateTime time) {
    setState(() {
      selectedTime = time;
    });
  }

  Future<void> submitPost() async {
    final supabase = Supabase.instance.client;
    // final session = supabase.auth.currentSession;
    // if (session == null) {
    //   print('❌ Supabase에 로그인된 세션 없음');
    //   return;
    // }
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'kakao_access_token');
    final refreshToken = await storage.read(key: 'kakao_refresh_token');
    print(accessToken);
    print(refreshToken);

    if (isKakaoLoggedIn() == false) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('카카오톡으로 로그인해주세요.')));
      return;
    }

    // ✅ 카카오 사용자 ID 가져오기
    String? kakaoId;
    try {
      final kakaoUser = await UserApi.instance.me();
      kakaoId = kakaoUser.id.toString();
    } catch (e) {
      print('❌ 카카오 사용자 정보 조회 실패: $e');
    }

    print('✏️ content: "$content"');
    print('🕒 selectedTime: $selectedTime');
    print('🔑 kakaoId: $kakaoId');

    if (kakaoId == null || selectedTime == null || content.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('모든 항목을 입력해주세요.')));
      return;
    }

    setState(() => isLoading = true);

    try {
      // ✅ Supabase Users 테이블에서 user_id 조회
      final userData = await supabase
          .from('Users')
          .select('user_id')
          .eq('kakao_id', kakaoId)
          .maybeSingle();

      if (userData == null) {
        throw Exception('Users 테이블에 유저 정보 없음');
      }

      final userId = userData['user_id'];

      // ✅ Board 테이블에 게시글 저장
      await supabase.from('Board').insert({
        'user_id': userId,
        'megaphone_time': selectedTime!.hour, // ERD상 int형
        'title': content.trim(),
        'likes': 0,
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('게시글이 작성되었습니다.')));
        Navigator.pop(context);
      }
    } catch (e) {
      print('❌ 게시글 저장 실패: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('게시글 저장에 실패했습니다.')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isReadyToPost = isContentNotEmpty && selectedTime != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const WritePostHeader(),
              TimeSlotSelector(onTimeSelected: onTimeSelected),
              PostContentInput(onChanged: onContentChanged),
              const TipBox(),
              WriteButton(
                isEnabled: isReadyToPost && !isLoading,
                isLoading: isLoading,
                onPressed: submitPost,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
