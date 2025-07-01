import 'package:flutter/material.dart';
import 'package:megaphone/otherpeople_profile_widgets/otherpeople_profile_header.dart';
import 'package:megaphone/otherpeople_profile_widgets/otherpeople_profile_summary_section.dart';
import 'package:megaphone/otherpeople_profile_widgets/otherpeople_profile_stat_section.dart';
import 'package:megaphone/otherpeople_profile_widgets/otherpeople_profile_tab_section.dart';
import 'package:megaphone/otherpeople_profile_widgets/otherpeople_profile_megaphone_list.dart';
import 'package:megaphone/otherpeople_profile_widgets/otherpeople_profile_post_list.dart';

class OtherProfileScreen extends StatefulWidget {
  const OtherProfileScreen({super.key});

  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OtherPeopleProfileHeader(userId: '홍길동'),
      body: Column(
        children: [
          // const OtherPeopleProfileSummarySection(),
          const OtherPeopleProfileStatSection(),
          OtherPeopleProfileTabSection(
            selectedIndex: _selectedIndex,
            onTabSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: _selectedIndex == 0
                ? const OtherPeopleProfileHighlightList()
                : const OtherPeopleProfilePostList(),
          ),
        ],
      ),
    );
  }
}
