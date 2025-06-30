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
  DateTime? selectedDateTime;

  final GlobalKey<MegaphonePostListLatestState> latestKey =
  GlobalKey<MegaphonePostListLatestState>();

  @override
  void initState() {
    super.initState();

    // 앱 실행 시 현재 시각 기준 +1시간을 기본값으로 설정
    final now = DateTime.now().toUtc().add(const Duration(hours: 9));
    final nextHour = DateTime(now.year, now.month, now.day, now.hour + 1);
    selectedDateTime = nextHour;
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
    // selectedDateTime이 아직 null이면 로딩 인디케이터 표시
    if (selectedDateTime == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
        shape: const CircleBorder(),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (selectedTab == 'latest') {
              await latestKey.currentState?.fetchPosts();
            }
            setState(() {}); // TimeFilterBar rebuild 용도
          },
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const HomeHeader(),
              const MegaphoneCard(),
              TimeFilterBar(
                selectedDateTime: selectedDateTime!,
                onTimeSelected: onTimeSelected,
              ),
              SortTabBar(
                selectedTab: selectedTab,
                onTabChanged: onTabSelected,
              ),
              if (selectedTab == 'latest')
                MegaphonePostListLatest(
                  key: latestKey,
                  selectedDateTime: selectedDateTime!,
                )
              else
                MegaphonePostListLiked(
                  selectedDateTime: selectedDateTime!,
                )
            ],
          ),
        ),
      ),
    );
  }
}
