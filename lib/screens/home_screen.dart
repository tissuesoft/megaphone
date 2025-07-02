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

  Offset _dragStart = Offset.zero;
  Offset _dragUpdate = Offset.zero;

  @override
  void initState() {
    super.initState();
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

  void _handleSwipe() {
    final dx = _dragUpdate.dx - _dragStart.dx;

    if (dx < -50 && selectedTab == 'latest') {
      // 오른쪽에서 왼쪽 → 공감순으로 변경
      onTabSelected('liked');
    } else if (dx > 50 && selectedTab == 'liked') {
      // 왼쪽에서 오른쪽 → 최신순으로 변경
      onTabSelected('latest');
    }
  }

  @override
  Widget build(BuildContext context) {
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
            setState(() {});
          },
          child: ListView(
            padding: EdgeInsets.zero,
            physics: const AlwaysScrollableScrollPhysics(),
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
              // 👉 여기만 스와이프 가능하게 GestureDetector로 감쌈
              GestureDetector(
                onHorizontalDragStart: (details) {
                  _dragStart = details.globalPosition;
                },
                onHorizontalDragUpdate: (details) {
                  _dragUpdate = details.globalPosition;
                },
                onHorizontalDragEnd: (details) {
                  _handleSwipe();
                },
                child: selectedTab == 'latest'
                    ? MegaphonePostListLatest(
                  key: latestKey,
                  selectedDateTime: selectedDateTime!,
                )
                    : MegaphonePostListLiked(
                  selectedDateTime: selectedDateTime!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
