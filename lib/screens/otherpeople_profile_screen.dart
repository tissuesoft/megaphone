import 'package:flutter/material.dart';
import 'package:megaphone/otherpeople_profile_widgets/otherpeople_profile_header.dart';
import 'package:megaphone/otherpeople_profile_widgets/otherpeople_profile_stat_section.dart';
import 'package:megaphone/otherpeople_profile_widgets/otherpeople_profile_tab_section.dart';
import 'package:megaphone/otherpeople_profile_widgets/otherpeople_profile_megaphone_list.dart';
import 'package:megaphone/otherpeople_profile_widgets/otherpeople_profile_post_list.dart';

class OtherProfileScreen extends StatefulWidget {
  final userId;

  const OtherProfileScreen({super.key, required this.userId});

  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  int _selectedIndex = 0;

  Offset _dragStart = Offset.zero;
  Offset _dragUpdate = Offset.zero;

  void _handleSwipe() {
    final dx = _dragUpdate.dx - _dragStart.dx;

    if (dx < -50 && _selectedIndex == 0) {
      // 오른쪽 → 왼쪽 스와이프 → 게시글 탭으로
      setState(() {
        _selectedIndex = 1;
      });
    } else if (dx > 50 && _selectedIndex == 1) {
      // 왼쪽 → 오른쪽 스와이프 → 고확기록 탭으로
      setState(() {
        _selectedIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: OtherPeopleProfileHeader(userId: widget.userId),
      body: Column(
        children: [
          OtherPeopleProfileStatSection(userId: widget.userId),
          OtherPeopleProfileTabSection(
            selectedIndex: _selectedIndex,
            onTabSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          Expanded(
            // 👉 스와이프 감지 영역
            child: GestureDetector(
              onHorizontalDragStart: (details) {
                _dragStart = details.globalPosition;
              },
              onHorizontalDragUpdate: (details) {
                _dragUpdate = details.globalPosition;
              },
              onHorizontalDragEnd: (details) {
                _handleSwipe();
              },
              child: _selectedIndex == 0
                  ? OtherProfileHighlightList(userId: widget.userId)
                  : OtherPeopleProfilePostList(userId: widget.userId),
            ),
          ),
        ],
      ),
    );
  }
}
