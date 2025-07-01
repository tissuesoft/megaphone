import 'package:flutter/material.dart';
import 'package:megaphone/myprofile_widgets/myprofile_header.dart';
import 'package:megaphone/myprofile_widgets/myprofile_summary_section.dart';
import 'package:megaphone/myprofile_widgets/myprofile_stat_section.dart';
import 'package:megaphone/myprofile_widgets/myprofile_tab_section.dart';
import 'package:megaphone/myprofile_widgets/myprofile_megaphone_list.dart'; // 고확 기록 리스트
import 'package:megaphone/myprofile_widgets/myprofile_post_list.dart';     // 내가 쓴 게시글 리스트

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
      backgroundColor: Colors.white, // 상태바 포함 전체 배경 흰색 유지
      body: Column(
        children: [
          const ProfileHeader(),               // 상단바 (타이틀 + 설정 아이콘)
          const MyProfileStatSection(),        // 고확 당첨 / 작성 글 / 받은 공감
          MyProfileTabSection(                 // 고확 기록 / 게시글 탭
            selectedIndex: selectedTabIndex,
            onTabSelected: (index) {
              setState(() {
                selectedTabIndex = index;
              });
            },
          ),
          Expanded(
            child: selectedTabIndex == 0
                ? const MyProfileHighlightList() // 고확 기록 리스트
                : const MyProfilePostList(),      // 내가 쓴 게시글 리스트
          ),
        ],
      ),
    );
  }
}
