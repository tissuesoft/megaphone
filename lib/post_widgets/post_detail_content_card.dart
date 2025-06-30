import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // ✅ 이거 꼭 있어야 함
import 'package:megaphone/screens/otherpeople_profile_screen.dart';

class PostDetailContentCard extends StatefulWidget {
  final dynamic postData;

  const PostDetailContentCard({super.key, required this.postData});

  @override
  State<PostDetailContentCard> createState() => _PostDetailContentCardState();
}

class _PostDetailContentCardState extends State<PostDetailContentCard> {
  late bool isLiked;
  late int likeCount;

  @override
  void initState() {
    super.initState();
    isLiked = false;
    likeCount = widget.postData['likes'] ?? 0;
  }

  void _toggleLike() async {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });

    final supabase = Supabase.instance.client;
    final boardId = widget.postData['board_id'];

    try {
      await supabase
          .from('Board')
          .update({'likes': likeCount})
          .eq('board_id', boardId);
    } catch (e) {
      print('❌ 좋아요 업데이트 실패: $e');

      // 실패하면 원래 상태로 롤백
      setState(() {
        isLiked = !isLiked;
        likeCount += isLiked ? 1 : -1;
      });
    }
  }


  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OtherProfileScreen()),
    );
  }

  String _getRemainingTimeText(String rawTime) {
    try {
      final deadline = DateTime.parse(rawTime);
      final now = DateTime.now();
      final remaining = deadline.difference(now);

      if (remaining.isNegative) {
        return '마감되었습니다';
      }

      final hours = remaining.inHours;
      final minutes = remaining.inMinutes.remainder(60);

      if (hours == 0 && minutes > 0) {
        return '마감까지 ${minutes}분';
      } else if (hours > 0 && minutes == 0) {
        return '마감까지 ${hours}시간';
      } else {
        return '마감까지 ${hours}시간 ${minutes}분';
      }
    } catch (e) {
      return '마감 시간 계산 불가';
    }
  }

  String _getTimeAgoText(String createdAtString) {
    try {
      final createdAt = DateTime.parse(createdAtString).toLocal();
      final now = DateTime.now();
      final difference = now.difference(createdAt);

      if (difference.inMinutes < 1) return '방금 전';
      if (difference.inMinutes < 60) return '${difference.inMinutes}분 전';
      if (difference.inHours < 24) return '${difference.inHours}시간 전';
      if (difference.inDays == 1) return '어제';
      if (difference.inDays < 7) return '${difference.inDays}일 전';
      return '${createdAt.month}월 ${createdAt.day}일';
    } catch (e) {
      return '시간 알 수 없음';
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.postData;
    final user = data['Users'] ?? {};
    final userNickname = user['user_nickname'] ?? '알 수 없음';
    final usedMegaphone = int.tryParse(user['used_megaphone']?.toString() ?? '0') ?? 0;
    final title = data['title'] ?? '';
    final createdAt = data['created_at'] ?? '';
    final megaphoneTime = data['megaphone_time'] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 상단: 프로필
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
            ),
          ),
          child: GestureDetector(
            onTap: _goToProfile,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/profile_drinking.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          Text(
                            userNickname,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFED7AA),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset('assets/megaphoneCountIcon.png', width: 12, height: 12),
                                const SizedBox(width: 4),
                                Text(
                                  '$usedMegaphone회',
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                    color: Color(0xFF9A3412),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _getTimeAgoText(createdAt),
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 본문 텍스트
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              height: 1.6,
              color: Color(0xFF111827),
            ),
          ),
        ),

        // 하단: 크라운 아이콘 + 마감 텍스트
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            width: double.infinity,
            height: 24,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 가운데 크라운 + 좋아요 수
                GestureDetector(
                  onTap: _toggleLike,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        isLiked
                            ? 'assets/crown_icon_likes+1.png'
                            : 'assets/crown_icon_likes.png',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$likeCount',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFF6B35),
                        ),
                      ),
                    ],
                  ),
                ),
                // 오른쪽 마감 텍스트
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _getRemainingTimeText(megaphoneTime),
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
