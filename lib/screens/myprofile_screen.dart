import 'package:flutter/material.dart';
import 'package:megaphone/myprofile_widgets/myprofile_header.dart';
import 'package:megaphone/myprofile_widgets/myprofile_stat_section.dart';
import 'package:megaphone/myprofile_widgets/myprofile_tab_section.dart';
import 'package:megaphone/myprofile_widgets/myprofile_megaphone_list.dart';
import 'package:megaphone/myprofile_widgets/myprofile_post_list.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedTabIndex = 0;

  Offset _dragStart = Offset.zero;
  Offset _dragUpdate = Offset.zero;

  void _handleSwipe() {
    final dx = _dragUpdate.dx - _dragStart.dx;

    if (dx < -50 && selectedTabIndex == 0) {
      // 오른쪽 → 왼쪽: 게시글로
      setState(() {
        selectedTabIndex = 1;
      });
    } else if (dx > 50 && selectedTabIndex == 1) {
      // 왼쪽 → 오른쪽: 고확기록으로
      setState(() {
        selectedTabIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ProfileHeader(),
          const MyProfileStatSection(),
          MyProfileTabSection(
            selectedIndex: selectedTabIndex,
            onTabSelected: (index) {
              setState(() {
                selectedTabIndex = index;
              });
            },
          ),
          Expanded(
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
              child: selectedTabIndex == 0
                  ? const MyProfileHighlightList()
                  : const MyProfilePostList(),
            ),
          ),
        ],
      ),
    );
  }
}
