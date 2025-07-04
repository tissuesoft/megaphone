import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:megaphone/screens/otherpeople_profile_screen.dart';
import 'package:megaphone/screens/post_screen.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class MegaphonePostListLatest extends StatefulWidget {
  final DateTime selectedDateTime;

  const MegaphonePostListLatest({super.key, required this.selectedDateTime});

  @override
  State<MegaphonePostListLatest> createState() => MegaphonePostListLatestState();
}

class MegaphonePostListLatestState extends State<MegaphonePostListLatest>
    with AutomaticKeepAliveClientMixin {
  List<dynamic> posts = [];
  bool isLoading = true;
  Map<int, int> likeCounts = {};
  Map<int, bool> likedStates = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<String?> getKakaoId() async {
    try {
      final kakaoUser = await UserApi.instance.me();
      return kakaoUser.id.toString();
    } catch (e) {
      print('❌ kakao_id 조회 실패: $e');
      return null;
    }
  }

  Future<void> fetchPosts() async {
    final supabase = Supabase.instance.client;
    final kakaoId = await getKakaoId();

    try {
      final response = await supabase
          .from('Board')
          .select('''
            board_id,
            title,
            created_at,
            likes,
            megaphone_time,
            Comment(count),
            Users (
              user_id,
              user_nickname,
              used_megaphone
            )
          ''')
          .order('board_id', ascending: false)
          .limit(50);

      setState(() {
        posts = response;
        for (var item in posts) {
          final boardId = item['board_id'];
          final likes = item['likes'] is List
              ? List<String>.from(item['likes'])
              : [];

          likeCounts[boardId] = likes.length;
          likedStates[boardId] = kakaoId != null && likes.contains(kakaoId);
        }
        isLoading = false;
      });
    } catch (e) {
      print('❌ 데이터 불러오기 오류: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
        child: Text('선택된 날짜와 시간에 해당하는 게시글이 없습니다.'),
      );
    }

    return Column(
      children: filteredPosts.map((item) {
        final user = item['Users'] ?? {};
        final userId = user['user_id'];
        final nickname = user['user_nickname'] ?? '알 수 없음';
        final usedMegaphone =
            int.tryParse(user['used_megaphone']?.toString() ?? '0') ?? 0;
        // ✅ created_at → toLocal() 적용 (String 또는 DateTime 모두 처리)
        final createdAtRaw = item['created_at'];
        late final DateTime createdAt;

        if (createdAtRaw is String) {
          createdAt = DateTime.parse(createdAtRaw).toUtc().add(const Duration(hours: 9));
        } else if (createdAtRaw is DateTime) {
          createdAt = createdAtRaw.toUtc().add(const Duration(hours: 9));
        } else {
          createdAt = DateTime.now();
        }

        final postDateTime =
            DateTime.tryParse(item['megaphone_time'] ?? '') ?? DateTime.now();
        final postTime = DateFormat('HH:mm').format(postDateTime.toLocal());
        final timeAgo = _getTimeAgo(createdAt);
        final remaining = _getRemainingTime(postDateTime);
        final boardId = item['board_id'];
        final commentCount =
        item['Comment'] is List && item['Comment'].isNotEmpty
            ? item['Comment'][0]['count'] ?? 0
            : 0;
        List<String> likes = item['likes'] is List
            ? List<String>.from(item['likes'])
            : [];
        bool isLiked = likedStates[boardId] ?? false;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PostScreen(boardId: boardId)),
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
                // 유저 정보
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OtherProfileScreen(
                              userId: userId.toString(),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
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
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () async {
                            final kakaoId = await getKakaoId();
                            if (kakaoId == null) {
                              print('❌ 사용자 kakao_id 없음');
                              return;
                            }

                            final supabase = Supabase.instance.client;

                            List<String> likedUserList = item['likes'] is List
                                ? List<String>.from(item['likes'])
                                : [];

                            final alreadyLiked = likedUserList.contains(kakaoId);

                            if (alreadyLiked) {
                              likedUserList.remove(kakaoId);
                            } else {
                              likedUserList.add(kakaoId);
                            }

                            try {
                              await supabase
                                  .from('Board')
                                  .update({'likes': likedUserList})
                                  .eq('board_id', boardId);
                            } catch (e) {
                              print('❌ Supabase 오류: $e');
                              return;
                            }

                            if (!mounted) return;

                            setState(() {
                              likedStates[boardId] = !alreadyLiked;
                              likeCounts[boardId] = likedUserList.length;
                              item['likes'] = likedUserList;
                            });
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                isLiked
                                    ? 'assets/crown_icon_likes+1.png'
                                    : 'assets/crown_icon_likes.png',
                                width: 16,
                                height: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${likeCounts[boardId] ?? 0}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFFF6B35),
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Image.asset('assets/comment_icon.png', width: 16),
                        const SizedBox(width: 4),
                        Text(
                          '$commentCount',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFFF6B35),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
