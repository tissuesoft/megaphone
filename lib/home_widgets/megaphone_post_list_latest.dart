// ✂️ imports 동일
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:megaphone/screens/otherpeople_profile_screen.dart';
import 'package:megaphone/screens/post_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MegaphonePostListLatest extends StatefulWidget {
  final DateTime selectedDateTime;

  const MegaphonePostListLatest({super.key, required this.selectedDateTime});

  @override
  State<MegaphonePostListLatest> createState() =>
      MegaphonePostListLatestState();
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
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'kakao_access_token') ?? null;
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
          // likes가 배열(jsonb)이므로 length로 카운트
          likeCounts[boardId] = (item['likes'] is List)
              ? item['likes'].length
              : 0;
          // 좋아요 상태는 기본값 false (실제 유저별 상태는 UI에서 처리)
          likedStates[boardId] = false;
        }
        isLoading = false;
      });
    } catch (e) {
      print('❌ 데이터 불러오기 오류: $e');
      setState(() {
        isLoading = false;
      });
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

    // filteredPosts.sort((a, b) {
    //   final aCreated = DateTime.tryParse(a['created_at'] ?? '') ?? DateTime(2000);
    //   final bCreated = DateTime.tryParse(b['created_at'] ?? '') ?? DateTime(2000);
    //   return bCreated.compareTo(aCreated); // 최신순
    // });

    if (filteredPosts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Text('선택된 날짜와 시간에 해당하는 게시글이 없습니다.'),
      );
    }

    return Column(
      children: filteredPosts.map((item) {
        final user = item['Users'] ?? {};
        final userId = item['Users']?['user_id']; // ✅ user_id 추출
        final nickname = user['user_nickname'] ?? '알 수 없음';
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
        final commentCount =
            item['Comment'] is List && item['Comment'].isNotEmpty
            ? item['Comment'][0]['count'] ?? 0
            : 0;
        List<String> likesCount = item['likes'] is List
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
                            ), // ✅ 여기!
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
                            if (kakaoId == null) return;

                            // 기존 likes(jsonb) 배열 가져오기
                            final supabase = Supabase.instance.client;
                            Map<String, dynamic> boardRow = {};
                            try {
                              final res = await supabase
                                  .from('Board')
                                  .select('likes')
                                  .eq('board_id', boardId)
                                  .maybeSingle();
                              boardRow = res ?? {};
                            } catch (e) {
                              print('❌ likes 조회 실패: $e');
                            }

                            List<dynamic> likedUserList = [];
                            if (boardRow['likes'] is List) {
                              likedUserList = List<String>.from(
                                boardRow['likes'],
                              );
                            }

                            final alreadyLiked = likedUserList.contains(
                              kakaoId,
                            );

                            if (alreadyLiked) {
                              likedUserList.remove(kakaoId);
                            } else {
                              likedUserList.add(kakaoId);
                            }

                            setState(() {
                              likedStates[boardId] = !alreadyLiked;
                              likeCounts[boardId] = likedUserList.length;
                            });

                            try {
                              await supabase
                                  .from('Board')
                                  .update({'likes': likedUserList})
                                  .eq('board_id', boardId);
                            } catch (e) {
                              print('❌ 좋아요 업데이트 실패: $e');
                            }
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
                                '${likesCount.length}', // ← 좋아요 수를 likesCount.length로 표시
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
