import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../home_widgets/home_header.dart';
import '../home_widgets/megaphone_card.dart';
import '../home_widgets/time_filter_bar.dart';
import '../home_widgets/sort_tab_bar.dart';
import '../home_widgets/megaphone_post_list_latest.dart'; // <-- 여기도 수정 반영됨
import '../home_widgets/megaphone_post_list_liked.dart';
import '../screens/write_post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedTab = 'latest';
  String selectedTime = '';
  DateTime selectedDate = DateTime.now();

  // ✅ 최신순 리스트를 제어할 수 있는 키
  final GlobalKey<MegaphonePostListLatestState> latestKey =
  GlobalKey<MegaphonePostListLatestState>();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now().toUtc().add(const Duration(hours: 9));
    final nextHour = DateTime(now.year, now.month, now.day, now.hour + 1);
    final formatter = DateFormat('HH:00');
    selectedTime = formatter.format(nextHour);
  }

  void onTabSelected(String tab) {
    setState(() {
      selectedTab = tab;
    });
  }

  void onTimeSelected(String time) {
    setState(() {
      selectedTime = time;
    });
  }

  DateTime get selectedDateTime {
    final parts = selectedTime.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour,
      minute,
    );
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
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (selectedTab == 'latest') {
              await latestKey.currentState?.fetchPosts(); // ✅ 핵심
            }
            setState(() {}); // 스크롤 유지 및 새로 빌드
          },
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const HomeHeader(),
              const MegaphoneCard(),
              TimeFilterBar(
                selectedTime: selectedTime,
                onTimeSelected: onTimeSelected,
              ),
              SortTabBar(
                selectedTab: selectedTab,
                onTabChanged: onTabSelected,
              ),
              if (selectedTab == 'latest')
                MegaphonePostListLatest(
                  key: latestKey, // ✅ 연결
                  selectedDateTime: selectedDateTime,
                )
              else
                const MegaphonePostListLiked(),
            ],
          ),
        ),
      ),
    );
  }
}
