import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../home_widgets/home_header.dart';
import '../home_widgets/megaphone_card.dart';
import '../home_widgets/time_filter_bar.dart';
import '../home_widgets/sort_tab_bar.dart';
import '../home_widgets/megaphone_post_list_latest.dart';
import '../home_widgets/megaphone_post_list_liked.dart';
import '../screens/write_post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedTab = 'latest';
  late DateTime selectedDateTime;

  final GlobalKey<MegaphonePostListLatestState> latestKey =
  GlobalKey<MegaphonePostListLatestState>();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now().toUtc().add(const Duration(hours: 9));
    final nextHour = DateTime(now.year, now.month, now.day, now.hour + 1);
    selectedDateTime = nextHour; // 시작은 다음 시간
  }

  void onTimeSelected(DateTime time) {
    setState(() {
      selectedDateTime = time;
    });
  }

  void onTabSelected(String tab) {
    setState(() {
      selectedTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const WritePostScreen()),
          );
        },
        backgroundColor: const Color(0xFFFF6B35),
        shape: const CircleBorder(), // ✅ 항상 원형 버튼 유지
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (selectedTab == 'latest') {
              await latestKey.currentState?.fetchPosts();
            }
            setState(() {});
          },
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const HomeHeader(),
              const MegaphoneCard(),
              TimeFilterBar(
                selectedDateTime: selectedDateTime,
                onTimeSelected: onTimeSelected,
              ),
              SortTabBar(
                selectedTab: selectedTab,
                onTabChanged: onTabSelected,
              ),
              if (selectedTab == 'latest')
                MegaphonePostListLatest(
                  key: latestKey,
                  selectedDateTime: selectedDateTime,
                )
              else
                MegaphonePostListLiked(
                  selectedDateTime: selectedDateTime,
                )
            ],
          ),
        ),
      ),
    );
  }
}
