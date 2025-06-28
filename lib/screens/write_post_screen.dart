import 'package:flutter/material.dart';
import '../write_post_widgets/write_post_header.dart';
import '../write_post_widgets/time_slot_selector.dart';
import '../write_post_widgets/post_content_input.dart';
import '../write_post_widgets/tip_box.dart';
import '../write_post_widgets/write_button.dart';

class WritePostScreen extends StatefulWidget {
  const WritePostScreen({super.key});

  @override
  State<WritePostScreen> createState() => _WritePostScreenState();
}

class _WritePostScreenState extends State<WritePostScreen> {
  bool isContentNotEmpty = false;

  void onContentChanged(String content) {
    setState(() {
      isContentNotEmpty = content.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const WritePostHeader(),
              const TimeSlotSelector(),
              PostContentInput(onChanged: onContentChanged),
              const TipBox(),
              WriteButton(
                isEnabled: isContentNotEmpty,
                onPressed: () {
                  if (isContentNotEmpty) {
                    print('게시글 작성됨!');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}