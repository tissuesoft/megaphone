import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:megaphone/screens/otherpeople_profile_screen.dart';
import 'package:megaphone/screens/post_screen.dart';

class MegaphonePostListLiked extends StatefulWidget {
  const MegaphonePostListLiked({super.key});

  @override
  State<MegaphonePostListLiked> createState() => _MegaphonePostListLikedState();
}

class _MegaphonePostListLikedState extends State<MegaphonePostListLiked> {
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
      final response = await supabase
          .from('Board')
          .select('''
            board_id,
            title,
            created_at,
            likes,
            megaphone_time,
            Users (
              user_nickname,
              user_image,
              used_megaphone
            )
          ''')
          .order('likes', ascending: false)
          .limit(50);

      setState(() {
        posts = response;
        isLoading = false;
      });
    } catch (e) {
      print('❌ 공감순 데이터 오류: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    if (posts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Text('공감순 게시글이 없습니다.'),
      );
    }

    return Column(
      children: posts.map((item) {
        final user = item['Users'] ?? {};
        final nickname = user['user_nickname'] ?? '알 수 없음';
        final profileImage = user['user_image'] ?? '';
        final isNetworkImage = profileImage.startsWith('http');
        final usedMegaphone =
            int.tryParse(user['used_megaphone']?.toString() ?? '0') ?? 0;

        final createdAt =
            DateTime.tryParse(item['created_at'] ?? '') ?? DateTime.now();
        final postDateTime = DateTime.tryParse(item['megaphone_time'] ?? '') ??
            DateTime.now();
        final postTime = DateFormat('HH:mm').format(postDateTime.toLocal());
        final timeAgo = _getTimeAgo(createdAt);
        final remaining = _getRemainingTime(postDateTime);
        final boardId = item['board_id'];
        final commentCount = item['comment_count'] ?? 0;
        final likeCount = item['likes'] ?? 0;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PostScreen()),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF9CA3AF)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단: 유저 정보
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OtherProfileScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: isNetworkImage
                                ? NetworkImage(profileImage)
                                : AssetImage(profileImage) as ImageProvider,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            nickname,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (usedMegaphone > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFED7AA),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/megaphoneCountIcon.png',
                                    width: 12,
                                    height: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$usedMegaphone회',
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF9A3412),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Text(
                      postTime,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  timeAgo,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item['title'] ?? '내용 없음',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.favorite, size: 16, color: Colors.red),
                        const SizedBox(width: 4),
                        Text('$likeCount'),
                        const SizedBox(width: 16),
                        Image.asset('assets/comment_icon.png', width: 16),
                        const SizedBox(width: 4),
                        Text('$commentCount'),
                      ],
                    ),
                    Text(
                      remaining,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getTimeAgo(DateTime createdAt) {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    return '${diff.inDays}일 전';
  }

  String _getRemainingTime(DateTime target) {
    final now = DateTime.now();
    final diff = target.difference(now);
    if (diff.inMinutes <= 0) return '마감됨';
    return '${diff.inHours}시간 ${diff.inMinutes % 60}분 남음';
  }
}
