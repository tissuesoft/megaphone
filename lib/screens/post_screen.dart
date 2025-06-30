// post_screen.dart
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

  @override
  void initState() {
    super.initState();
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
              used_megaphone
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PostHeader(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : postData == null
          ? const Center(child: Text('게시글을 찾을 수 없습니다.'))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostDetailContentCard(postData: postData), // ✅ 통째로 넘김
            const PostCommentList(),
          ],
        ),
      ),
      bottomNavigationBar: const CommentInputBar(),
    );
  }
}
