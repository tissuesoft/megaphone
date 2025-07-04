import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../post_widgets/post_header.dart';
import '../post_widgets/post_detail_content_card.dart';
import '../post_widgets/post_comment_list.dart';
import '../post_widgets/comment_input_bar.dart';

class PostScreen extends StatefulWidget {
  final int boardId;

  const PostScreen({super.key, required this.boardId});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool isLoading = true;
  dynamic postData;

  late final GlobalKey<PostCommentListState> commentListKey;

  @override
  void initState() {
    super.initState();
    commentListKey = GlobalKey<PostCommentListState>();
    fetchPostData();
  }

  Future<void> fetchPostData() async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from('Board')
          .select('''
            board_id,
            title,
            likes,
            megaphone_time,
            created_at,
            Users (
              user_id,
              user_nickname,
              used_megaphone,
              kakao_id
            )
          ''')
          .eq('board_id', widget.boardId)
          .maybeSingle();

      setState(() {
        postData = response;
        isLoading = false;
      });
    } catch (e) {
      print('❌ 게시글 데이터 가져오기 실패: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void refreshComments() {
    commentListKey.currentState?.fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // 핵심! 키보드 올라올 때 자동 밀어줌
      backgroundColor: Colors.white,
      appBar: isLoading || postData == null
          ? AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '게시글 상세',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      )
          : PostHeader(
        postData: postData,
        onDelete: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('게시글이 삭제되었습니다.')),
          );
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : postData == null
          ? const Center(child: Text('게시글을 찾을 수 없습니다.'))
          : Column(
        children: [
          // 댓글 영역
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80), // 댓글창 높이만큼
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PostDetailContentCard(postData: postData),
                  PostCommentList(
                    key: commentListKey,
                    boardId: widget.boardId,
                  ),
                ],
              ),
            ),
          ),

          // 댓글 입력창 (항상 아래 고정)
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Material(
            elevation: 8,
            color: Colors.white,
            child: CommentInputBar(
              boardId: widget.boardId,
              onSubmit: refreshComments,
            ),
          ),
        ],
      ),
    );
  }
}
