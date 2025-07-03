import 'package:flutter/material.dart';
import 'package:megaphone/screens/post_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OtherPeopleProfilePostList extends StatefulWidget {
  final String userId; // 상대 유저의 user_id

  const OtherPeopleProfilePostList({super.key, required this.userId});

  @override
  State<OtherPeopleProfilePostList> createState() => _OtherPeopleProfilePostListState();
}

class _OtherPeopleProfilePostListState extends State<OtherPeopleProfilePostList> {
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
      final res = await supabase
          .from('Board')
          .select('''
            board_id,
            title,
            likes,
            megaphone_time,
            created_at,
            Comment(count)
          ''')
          .eq('user_id', widget.userId)
          .order('created_at', ascending: false);

      setState(() {
        posts = res;
        isLoading = false;
      });
    } catch (e) {
      print('❌ 상대 게시글 로딩 실패: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('상대 게시글을 불러오지 못했습니다.')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  int getCommentCount(dynamic post) {
    if (post['Comment'] is List && post['Comment'].isNotEmpty) {
      return post['Comment'][0]['count'] ?? 0;
    }
    return 0;
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
        final commentCount = getCommentCount(post);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PostScreen(boardId: post['board_id']),
              ),
            );
          },
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단: 날짜 + 좋아요/댓글
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      post['megaphone_time']?.substring(0, 16)?.replaceAll('T', ' ') ?? '',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/crown_icon_likes+1.png',
                          width: 14,
                          height: 14,
                        ),
                        const SizedBox(width: 4),
                        Text('${post['likes'] ?? 0}'),
                        const SizedBox(width: 12),
                        Image.asset(
                          'assets/comment_icon.png',
                          width: 14,
                          height: 14,
                        ),
                        const SizedBox(width: 4),
                        Text('$commentCount'),
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
