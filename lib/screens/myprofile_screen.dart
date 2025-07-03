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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ProfileHeader(),                    // 상단 타이틀 + 설정
          const MyProfileStatSection(),            // ✅ 고확/글/공감 데이터 로드됨
          MyProfileTabSection(                     // ✅ 탭 전환
            selectedIndex: selectedTabIndex,
            onTabSelected: (index) {
              setState(() {
                selectedTabIndex = index;
              });
            },
          ),
          Expanded(
            child: selectedTabIndex == 0
                ? const MyProfileHighlightList()   // ✅ 고확 당첨 글 목록
                : const MyProfilePostList(),       // ✅ 전체 작성 글 목록
          ),
        ],
      ),
    );
  }
}
