import 'package:flutter/material.dart';
import 'package:megaphone/screens/otherpeople_profile_screen.dart';

class PostCommentList extends StatelessWidget {
  const PostCommentList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 0),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/comment_icon.png',
                width: 16,
                height: 16,
              ),
              SizedBox(width: 6),
              Text(
                '18',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF6B35),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Divider(height: 1, color: Color(0xFFF3F4F6)),

        PostCommentItem(
          username: '밥순이',
          profileImage: 'assets/bab.jpg',
          content: 'ㅋㅋㅋ 진짜 현실적이네 편의점이 최고지',
          timeAgo: '1분 전',
          likeCount: 8,
        ),
        PostCommentItem(
          username: '점심러버',
          profileImage: 'assets/kim1.jpg',
          content: '아니 왜 이렇게 공감되냐 ㅠㅠ',
          timeAgo: '2분 전',
          likeCount: 12,
          badge: '1회',
        ),
        PostCommentItem(
          username: '현실주의자',
          profileImage: 'assets/choi.jpg',
          content: '편의점 삼각김밥 + 바나나우유 조합 인정?',
          timeAgo: '5분 전',
          likeCount: 8,
        ),
      ],
    );
  }
}

class PostCommentItem extends StatefulWidget {
  final String username;
  final String profileImage;
  final String content;
  final String timeAgo;
  final int likeCount;
  final String? badge;

  const PostCommentItem({
    super.key,
    required this.username,
    required this.profileImage,
    required this.content,
    required this.timeAgo,
    required this.likeCount,
    this.badge,
  });

  @override
  State<PostCommentItem> createState() => _PostCommentItemState();
}

class _PostCommentItemState extends State<PostCommentItem> {
  bool isLiked = false;
  late int currentLikes;

  @override
  void initState() {
    super.initState();
    currentLikes = widget.likeCount;
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      currentLikes += isLiked ? 1 : -1;
    });
  }

  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OtherProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 프로필 이미지 (클릭 가능)
                  GestureDetector(
                    onTap: _goToProfile,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage(widget.profileImage),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 우측 텍스트 정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 유저명 + 뱃지
                        GestureDetector(
                          onTap: _goToProfile,
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 6,
                            children: [
                              Text(
                                widget.username,
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              if (widget.badge != null && widget.badge!.isNotEmpty)
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
                                        widget.badge!,
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
                        ),
                        const SizedBox(height: 4),

                        // 댓글 내용
                        Text(
                          widget.content,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            color: Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // 시간, 좋아요, 답글
                        Row(
                          children: [
                            Text(
                              widget.timeAgo,
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: _toggleLike,
                              behavior: HitTestBehavior.translucent,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      isLiked ? Icons.favorite : Icons.favorite_border,
                                      size: 14,
                                      color: Color(0xFFFF6B35),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$currentLikes',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF9FAFB)),
          ],
        );
      },
    );
  }
}
