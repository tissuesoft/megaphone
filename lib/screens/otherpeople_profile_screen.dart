import 'package:flutter/material.dart';
import 'package:megaphone/otherpeople_profile_widgets/otherpeople_profile_header.dart';
import 'package:megaphone/otherpeople_profile_widgets/otherpeople_profile_summary_section.dart';
import 'package:megaphone/otherpeople_profile_widgets/otherpeople_profile_stat_section.dart';
import 'package:megaphone/otherpeople_profile_widgets/otherpeople_profile_tab_section.dart';
import 'package:megaphone/otherpeople_profile_widgets/otherpeople_profile_megaphone_list.dart';
import 'package:megaphone/otherpeople_profile_widgets/otherpeople_profile_post_list.dart';

class OtherProfileScreen extends StatefulWidget {
  final userId; // ✅ 전달받는 상대방 유저의 ID

  const OtherProfileScreen({super.key, required this.userId});

  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OtherPeopleProfileHeader(userId: widget.userId), // ✅ 헤더에 userId 전달
      body: Column(
        children: [
          // 유저 통계 (고확 수, 작성 글 수, 받은 공감 수)
          OtherPeopleProfileStatSection(userId: widget.userId), // ✅ 통계 위젯에 userId 전달

          // 탭 선택 (고확기록 or 게시글)
          OtherPeopleProfileTabSection(
            selectedIndex: _selectedIndex,
            onTabSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),

          // 리스트 출력 (선택된 탭에 따라 분기)
          Expanded(
            child: _selectedIndex == 0
                ? OtherProfileHighlightList(userId: widget.userId) // ✅ 고확기록 리스트
                : OtherPeopleProfilePostList(userId: widget.userId),     // ✅ 게시글 리스트
          ),
        ],
      ),
    );
  }
}
