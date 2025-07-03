import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:megaphone/screens/otherpeople_profile_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostCommentList extends StatefulWidget {
  final int boardId;

  const PostCommentList({super.key, required this.boardId});

  @override
  State<PostCommentList> createState() => PostCommentListState();
}

class PostCommentListState extends State<PostCommentList> {
  List<dynamic> comments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<void> fetchComments() async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from('Comment')
          .select('''
            comment_id,
            comment,
            created_at,
            likes,
            Users (
              user_id,
              user_nickname,
              used_megaphone
            )
          ''')
          .eq('board_id', widget.boardId)
          .order('comment_id', ascending: false);

      setState(() {
        comments = response;
        isLoading = false;
      });
    } catch (e) {
      print('❌ 댓글 불러오기 실패: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatTimeAgo(String createdAt) {
    final created = DateTime.parse(createdAt).toLocal();
    final now = DateTime.now();
    final diff = now.difference(created);

    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    return '${diff.inDays}일 전';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/comment_icon.png', width: 16, height: 16),
              const SizedBox(width: 6),
              Text(
                '${comments.length}',
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
        const SizedBox(height: 8),
        const Divider(height: 1, color: Color(0xFFF3F4F6)),
        for (var comment in comments)
          PostCommentItem(
            commentId: comment['comment_id'],
            userId: comment['Users']['user_id'],
            username: comment['Users']['user_nickname'],
            content: comment['comment'],
            timeAgo: _formatTimeAgo(comment['created_at']),
            likes: comment['likes'] is List
                ? List<String>.from(comment['likes'])
                : [],
            badge: (comment['Users']?['used_megaphone'] ?? 0) > 0
                ? '${comment['Users']?['used_megaphone']}회'
                : null,
          ),
      ],
    );
  }
}

class PostCommentItem extends StatefulWidget {
  final int commentId;
  final int userId;
  final String username;
  final String content;
  final String timeAgo;
  final List<dynamic> likes;
  final String? badge;

  const PostCommentItem({
    super.key,
    required this.commentId,
    required this.userId,
    required this.username,
    required this.content,
    required this.timeAgo,
    required this.likes,
    this.badge,
  });

  @override
  State<PostCommentItem> createState() => _PostCommentItemState();
}

class _PostCommentItemState extends State<PostCommentItem> {
  bool isLiked = false;
  List<String> likesList = [];

  @override
  void initState() {
    super.initState();
    likesList = widget.likes is List ? List<String>.from(widget.likes) : [];
    initLikeStatus();
  }

  Future<String?> getKakaoId() async {
    try {
      final kakaoUser = await UserApi.instance.me();
      return kakaoUser.id.toString();
    } catch (e) {
      print('❌ kakao_id 가져오기 실패: $e');
      return null;
    }
  }

  Future<void> initLikeStatus() async {
    final kakaoId = await getKakaoId();
    if (kakaoId == null) return;

    setState(() {
      isLiked = likesList.contains(kakaoId);
    });
  }

  void _toggleLike() async {
    final kakaoId = await getKakaoId();
    if (kakaoId == null) return;

    final supabase = Supabase.instance.client;
    final alreadyLiked = likesList.contains(kakaoId);

    if (alreadyLiked) {
      likesList.remove(kakaoId);
    } else {
      likesList.add(kakaoId);
    }

    try {
      await supabase
          .from('Comment')
          .update({'likes': likesList})
          .eq('comment_id', widget.commentId);

      if (!mounted) return;
      setState(() {
        isLiked = !alreadyLiked;
      });
    } catch (e) {
      print('❌ 댓글 좋아요 업데이트 실패: $e');
      setState(() {
        if (alreadyLiked) {
          likesList.add(kakaoId);
        } else {
          likesList.remove(kakaoId);
        }
        isLiked = alreadyLiked;
      });
    }
  }

  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtherProfileScreen(userId: widget.userId.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final likeCount = likesList.length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFED7AA),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/megaphoneCountIcon.png',
                                    width: 12,
                                    height: 12,
                                  ),
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
                    Text(
                      widget.content,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 6),
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
                                  color: const Color(0xFFFF6B35),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$likeCount',
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
              const SizedBox(width: 12),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFF9FAFB)),
      ],
    );
  }
}
