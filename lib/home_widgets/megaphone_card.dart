import 'dart:async';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:megaphone/screens/otherpeople_profile_screen.dart';
import 'package:megaphone/screens/post_screen.dart';

class MegaphoneCard extends StatefulWidget {
  const MegaphoneCard({super.key});

  @override
  State<MegaphoneCard> createState() => MegaphoneCardState ();
}

class MegaphoneCardState extends State<MegaphoneCard> {
  bool isLiked = false;
  dynamic megaphonePost;
  bool isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchTopPostForCurrentHour();
    _startHourlyRefresh();
  }

  void _startHourlyRefresh() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 9)); // KST
    final nextFullHour = DateTime(now.year, now.month, now.day, now.hour + 1);
    final durationUntilNextHour = nextFullHour.difference(now);

    Future.delayed(durationUntilNextHour, () {
      if (!mounted) return;

      _timer = Timer.periodic(const Duration(hours: 1), (timer) {
        fetchTopPostForCurrentHour();
      });

      fetchTopPostForCurrentHour();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchTopPostForCurrentHour() async {
    final supabase = Supabase.instance.client;

    final now = DateTime.now().toUtc().add(const Duration(hours: 9)); // KST
    final targetHour = DateTime(now.year, now.month, now.day, now.hour);
    final formatted = DateFormat("yyyy-MM-dd HH:00:00").format(targetHour);

    try {
      final response = await supabase
          .from('Board')
          .select('''
            board_id,
            user_id,
            title,
            likes,
            megaphone_win,
            megaphone_time,
            created_at,
            Users (
              user_id,
              user_nickname,
              used_megaphone
            )
          ''')
          .filter('megaphone_time', 'eq', formatted)
          .order('likes', ascending: false)
          .order('created_at', ascending: true) // 가장 먼저 작성한 글 우선
          .limit(1)
          .maybeSingle();

      if (response != null) {
        final boardId = response['board_id'];
        final userId = response['user_id'];

        // ✅ 이미 당첨된 글이면 +1 처리하지 않음
        if (response['megaphone_win'] != true) {
          // 게시글을 megaphone_win = true로 설정
          await supabase
              .from('Board')
              .update({'megaphone_win': true})
              .eq('board_id', boardId);

          // Users 테이블의 used_megaphone +1
          final userRes = response['Users'];
          final userId = userRes?['Users']?['user_id']; // ✅ user_id 추출
          final usedCountRaw = userRes?['used_megaphone'];
          final usedCount = usedCountRaw is int ? usedCountRaw : 0;
          final newUsed = usedCount + 1;

          await supabase
              .from('Users')
              .update({'used_megaphone': newUsed})
              .eq('user_id', userId);
        }

        if (!mounted) return;
        setState(() {
          megaphonePost = response;
          isLoading = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          megaphonePost = null;
          isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Supabase 오류: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatHour(dynamic timestamp) {
    try {
      final dt = DateTime.parse(timestamp);
      return '${dt.hour.toString().padLeft(2, '0')}:00';
    } catch (_) {
      return '시간오류';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (megaphonePost == null) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          '아직 이 시간대에 울린 고확이 없어요!',
          style: TextStyle(fontFamily: 'Montserrat'),
        ),
      );
    }

    final user = megaphonePost['Users'] ?? {};
    final nickname = user['user_nickname'] ?? '알 수 없음';
    final usedMegaphone = int.tryParse(user['used_megaphone']?.toString() ?? '0') ?? 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PostScreen(boardId: megaphonePost['board_id']),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 타이틀 & 시간
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/home_megaphone_icon.png',
                      width: 20,
                      height: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '지금 울리는 고확',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    formatHour(megaphonePost['megaphone_time']),
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 본문 텍스트 (전광판)
            SizedBox(
              height: 28,
              width: double.infinity,
              child: Marquee(
                text: megaphonePost['title'] ?? '',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.white,
                ),
                scrollAxis: Axis.horizontal,
                blankSpace: 60.0,
                velocity: 40.0,
                startPadding: 10.0,
                accelerationDuration: const Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: const Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
              ),
            ),
            const SizedBox(height: 16),

            // 하단 정보
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLiked = !isLiked;
                    });

                    final supabase = Supabase.instance.client;
                    final boardId = megaphonePost['board_id'];
                    final currentLikes = megaphonePost['likes'] ?? 0;
                    final newLikeCount = isLiked ? currentLikes + 1 : currentLikes - 1;

                    try {
                      await supabase
                          .from('Board')
                          .update({'likes': newLikeCount})
                          .eq('board_id', boardId);

                      setState(() {
                        megaphonePost['likes'] = newLikeCount;
                      });
                    } catch (e) {
                      print('❌ 좋아요 업데이트 실패: $e');
                    }
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        isLiked
                            ? 'assets/crown_icon_megaphone_card+1.png'
                            : 'assets/crown_icon_megaphone_card.png',
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        megaphonePost['likes'].toString(),
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                GestureDetector(
                  onTap: () {
                    final userId = megaphonePost['user_id'];

                    if (userId == null || userId.toString().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('유저 정보를 불러올 수 없습니다.')),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OtherProfileScreen(userId: userId.toString()),
                      ),
                    );
                  },
                  child: Text(
                    nickname,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                if (usedMegaphone > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
            ),
          ],
        ),
      ),
    );
  }
}
