import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:megaphone/screens/otherpeople_profile_screen.dart';
import 'package:megaphone/screens/post_screen.dart';

class MegaphonePostListLiked extends StatefulWidget {
  final DateTime selectedDateTime;

  const MegaphonePostListLiked({
    super.key,
    required this.selectedDateTime,
  });

  @override
  State<MegaphonePostListLiked> createState() => MegaphonePostListLikedState();
}

class MegaphonePostListLikedState extends State<MegaphonePostListLiked> {
  List<dynamic> posts = [];
  bool isLoading = true;
  Map<int, int> likeCounts = {};
  Map<int, bool> likedStates = {};

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
        for (var item in posts) {
          final boardId = item['board_id'];
          likeCounts[boardId] = item['likes'] ?? 0;
          likedStates[boardId] = false;
        }
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

    final filteredPosts = posts.where((item) {
      final rawTime = item['megaphone_time'];
      if (rawTime == null) return false;
      try {
        final postDateTime = DateTime.parse(rawTime).toLocal();
        final selected = widget.selectedDateTime;

        return postDateTime.year == selected.year &&
            postDateTime.month == selected.month &&
            postDateTime.day == selected.day &&
            postDateTime.hour == selected.hour &&
            postDateTime.minute == selected.minute;
      } catch (_) {
        return false;
      }
    }).toList();

    if (filteredPosts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Text('선택된 시간에 해당하는 공감순 게시글이 없습니다.'),
      );
    }

    return Column(
      children: filteredPosts.map((item) {
        final user = item['Users'] ?? {};
        final nickname = user['user_nickname'] ?? '알 수 없음';
        final profileImage = user['user_image'] ?? '';
        final isNetworkImage = profileImage.startsWith('http');
        final usedMegaphone =
            int.tryParse(user['used_megaphone']?.toString() ?? '0') ?? 0;

        final createdAt =
            DateTime.tryParse(item['created_at'] ?? '') ?? DateTime.now();
        final postDateTime =
            DateTime.tryParse(item['megaphone_time'] ?? '') ?? DateTime.now();
        final postTime = DateFormat('HH:mm').format(postDateTime.toLocal());
        final timeAgo = _getTimeAgo(createdAt);
        final remaining = _getRemainingTime(postDateTime);
        final boardId = item['board_id'];
        final commentCount = item['comment_count'] ?? 0;
        int likeCount = likeCounts[boardId] ?? 0;
        bool isLiked = likedStates[boardId] ?? false;

        return Container(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const OtherProfileScreen()),
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
                                horizontal: 8, vertical: 2),
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
                        fontFamily: 'Montserrat', fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                timeAgo,
                style:
                const TextStyle(fontFamily: 'Montserrat', fontSize: 12),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PostScreen()),
                  );
                },
                child: Text(
                  item['title'] ?? '내용 없음',
                  style: const TextStyle(
                      fontFamily: 'Montserrat', fontSize: 16),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            isLiked = !isLiked;
                            likeCount += isLiked ? 1 : -1;
                            likeCounts[boardId] = likeCount;
                            likedStates[boardId] = isLiked;
                          });

                          final supabase = Supabase.instance.client;
                          try {
                            await supabase
                                .from('Board')
                                .update({'likes': likeCount})
                                .eq('board_id', boardId);
                          } catch (e) {
                            print('❌ 좋아요 업데이트 실패: $e');
                          }
                        },
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 16,
                          color: isLiked ? Colors.red : Colors.black,
                        ),
                      ),
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
                        fontFamily: 'Montserrat', fontSize: 12),
                  ),
                ],
              ),
            ],
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
