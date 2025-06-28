import 'package:flutter/material.dart';
import '../post_widgets/post_header.dart';
import '../post_widgets/post_detail_content_card.dart';
import '../post_widgets/post_comment_list.dart';
import '../post_widgets/comment_input_bar.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PostHeader(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostDetailContentCard(),
            PostCommentList(),
            // TODO: 댓글 리스트 등 추가 가능
          ],
        ),
      ),
      bottomNavigationBar: const CommentInputBar(),
    );
  }
}
