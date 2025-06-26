//홈 화면
import 'package:flutter/material.dart';
import '../home_widgets/home_header.dart';
import '../home_widgets/megaphone_card.dart';
import '../home_widgets/time_filter_bar.dart';
import '../home_widgets/sort_tab_bar.dart';
import '../home_widgets/megaphone_post_list_latest.dart';
import '../home_widgets/megaphone_post_list_liked.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedTab = 'latest'; // 'latest' 또는 'liked'

  void onTabSelected(String tab) {
    setState(() {
      selectedTab = tab;
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
              const HomeHeader(),
              const MegaphoneCard(),
              const TimeFilterBar(),
              SortTabBar(
                selectedTab: selectedTab,
                onTabChanged: onTabSelected,
              ),
              if (selectedTab == 'latest')
                const MegaphonePostListLatest()
              else
                const MegaphonePostListLiked(),
            ],
          ),
        ),
      ),
    );
  }
}
