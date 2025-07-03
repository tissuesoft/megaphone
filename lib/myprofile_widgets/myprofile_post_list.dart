import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:megaphone/screens/post_screen.dart';

class MyProfilePostList extends StatefulWidget {
  const MyProfilePostList({super.key});

  @override
  State<MyProfilePostList> createState() => _MyProfilePostListState();
}

class _MyProfilePostListState extends State<MyProfilePostList> {
  List<dynamic> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final supabase = Supabase.instance.client;

    try {
      final kakaoUser = await UserApi.instance.me();
      final kakaoId = kakaoUser.id.toString();

      final userData = await supabase
          .from('Users')
          .select('user_id')
          .eq('kakao_id', kakaoId)
          .maybeSingle();

      if (userData == null) throw Exception('Users 테이블에 유저 정보 없음');

      final userId = userData['user_id'];

      final res = await supabase
          .from('Board')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      setState(() {
        posts = res;
        isLoading = false;
      });
    } catch (e) {
      print('❌ 내 게시글 로딩 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('내 게시글을 불러오지 못했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (posts.isEmpty) {
      return const Center(child: Text('작성한 게시글이 없습니다.'));
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: posts.length,
      separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF3F4F6)),
      itemBuilder: (context, index) {
        final post = posts[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostScreen(boardId: post['board_id']),
              ),
            );
          },
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 날짜 + 좋아요/댓글
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      post['created_at']?.substring(0, 16)?.replaceAll('T', ' ') ?? '',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.favorite, size: 14, color: Color(0xFFEF4444)),
                        const SizedBox(width: 4),
                        Text('${post['likes'] ?? 0}'),
                        const SizedBox(width: 12),
                        const Icon(Icons.chat_bubble_outline, size: 14),
                        const SizedBox(width: 4),
                        Text('${post['comments'] ?? 0}'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  post['title'] ?? '',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF1F2937),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
