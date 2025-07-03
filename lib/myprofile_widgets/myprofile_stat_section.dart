import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class MyProfileStatSection extends StatefulWidget {
  const MyProfileStatSection({super.key});

  @override
  State<MyProfileStatSection> createState() => _MyProfileStatSectionState();
}

class _MyProfileStatSectionState extends State<MyProfileStatSection> {
  int usedMegaphone = 0;
  int postCount = 0;
  int totalLikesReceived = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStats();
  }

  Future<void> fetchStats() async {
    final supabase = Supabase.instance.client;
    final storage = FlutterSecureStorage();

    try {
      final kakaoUser = await UserApi.instance.me();
      final kakaoId = kakaoUser.id.toString();

      final userData = await supabase
          .from('Users')
          .select('user_id')
          .eq('kakao_id', kakaoId)
          .maybeSingle();

      if (userData == null) {
        throw Exception('Users 테이블에서 사용자 정보를 찾을 수 없습니다.');
      }

      final userId = userData['user_id'];

      // ✅ 고확 당첨 수
      final userRes = await supabase
          .from('Users')
          .select('used_megaphone')
          .eq('user_id', userId)
          .single();

      final usedCountRaw = userRes['used_megaphone'];
      final usedCount = usedCountRaw is int ? usedCountRaw : 0;

      // ✅ 전체 게시글 데이터 불러오기 (likes 포함)
      final boardRes = await supabase
          .from('Board')
          .select('likes') // 꼭 likes 포함
          .eq('user_id', userId);

      int likeSum = 0;
      for (var post in boardRes) {
        final likes = post['likes'];
        if (likes is List) {
          likeSum += likes.length;
        }
      }

      if (!mounted) return;
      setState(() {
        usedMegaphone = usedCount;
        postCount = boardRes.length;
        totalLikesReceived = likeSum;
        isLoading = false;
      });

    } catch (e) {
      print('❌ MyProfile 통계 불러오기 실패: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('내 프로필 정보를 불러올 수 없습니다.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      height: 81,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _StatItem(
              count: isLoading ? '-' : usedMegaphone.toString(),
              label: '고확 당첨',
            ),
            _StatItem(
              count: isLoading ? '-' : postCount.toString(),
              label: '작성 글',
            ),
            _StatItem(
              count: isLoading ? '-' : totalLikesReceived.toString(),
              label: '받은 공감',
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;

  const _StatItem({
    super.key,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }
}
