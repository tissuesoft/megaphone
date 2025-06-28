import 'package:flutter/material.dart';
import 'package:megaphone/screens/otherpeople_profile_screen.dart';

class MegaphonePostCard extends StatefulWidget {
  final String profileImage;
  final String username;
  final String? badgeText;
  final String timeAgo;
  final String postTime;
  final String content;
  final int likes;
  final int comments;
  final String remaining;

  const MegaphonePostCard({
    super.key,
    required this.profileImage,
    required this.username,
    this.badgeText,
    required this.timeAgo,
    required this.postTime,
    required this.content,
    required this.likes,
    required this.comments,
    required this.remaining,
  });

  @override
  State<MegaphonePostCard> createState() => _MegaphonePostCardState();
}

class _MegaphonePostCardState extends State<MegaphonePostCard> {
  bool isLiked = false;
  late int likeCount;

  @override
  void initState() {
    super.initState();
    likeCount = widget.likes;
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
  }

  void _goToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OtherProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          // 상단: 프로필 + 이름 + 뱃지 + 시간
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => _goToProfile(context),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage(widget.profileImage),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.username,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (widget.badgeText != null && widget.badgeText!.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFED7AA),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Image.asset('assets/megaphoneCountIcon.png', width: 12, height: 12),
                            const SizedBox(width: 4),
                            Text(
                              widget.badgeText!,
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
                widget.postTime,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            widget.timeAgo,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.content,
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
                    onTap: _toggleLike,
                    child: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      size: 16,
                      color: isLiked ? Colors.red : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$likeCount',
                    style: const TextStyle(fontFamily: 'Montserrat'),
                  ),
                  const SizedBox(width: 16),
                  Image.asset(
                    'assets/comment_icon.png',
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.comments}',
                    style: const TextStyle(fontFamily: 'Montserrat'),
                  ),
                ],
              ),
              Text(
                widget.remaining,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MegaphonePostListLiked extends StatelessWidget {
  const MegaphonePostListLiked({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyPosts = [
      MegaphonePostCard(
        profileImage: 'assets/kim1.jpg',
        username: '박준호',
        badgeText: '1회',
        timeAgo: '2분 전',
        postTime: '12:00',
        content: '오늘 점심 메뉴 추천해주세요! 학교 앞 맛집 아시는 분?',
        likes: 24,
        comments: 7,
        remaining: '4시간 남음',
      ),
      MegaphonePostCard(
        profileImage: 'assets/bab.jpg',
        username: '밥순이',
        badgeText: '',
        timeAgo: '5분 전',
        postTime: '12:00',
        content: '도서관에서 같이 공부하실 분 구해요~ 3층에서 기다리고 있어요!',
        likes: 18,
        comments: 3,
        remaining: '4시간 남음',
      ),
      MegaphonePostCard(
        profileImage: 'assets/choi.jpg',
        username: '최민우',
        badgeText: '134회',
        timeAgo: '8분 전',
        postTime: '12:00',
        content: '급해요! 2교시 수업 교실 바뀐 곳 아시는 분 있나요?',
        likes: 12,
        comments: 5,
        remaining: '4시간 남음',
      ),
    ];

    return Column(children: dummyPosts);
  }
}
