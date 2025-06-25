import 'package:flutter/material.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  int selectedTab = 1; // 0 = 총 랭킹, 1 = 주간 랭킹

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '랭킹',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          if (selectedTab == 1) _buildWeeklyRanking() else _buildTotalRanking(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color(0xFFFF6B35),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: '랭킹'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Row(
      children: [
        _buildTab('총 랭킹', 0),
        _buildTab('주간 랭킹', 1),
      ],
    );
  }

  Widget _buildTab(String text, int index) {
    final isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFFFF6B35) : Colors.grey.shade300,
                width: 3,
              ),
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFFFF6B35) : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyRanking() {
    return Expanded(
      child: ListView(
        children: [
          _buildHighlightSection(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '전체 순위',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          _buildUserListTile(rank: 4, name: '최드립', count: 5),
          _buildUserListTile(rank: 5, name: '정알림', count: 4),
          _buildUserListTile(rank: 6, name: '홍메시지', count: 3),
          _buildUserListTile(rank: 7, name: '이홍준', count: 3),
        ],
      ),
    );
  }

  Widget _buildHighlightSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFA36C), Color(0xFFFF6B35)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const Text('이번 주 고확 왕', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const Text('12월 16일 - 12월 22일', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTopUser('김민수', '23회', 2),
              _buildTopUser('박지연', '47회', 1, crown: true),
              _buildTopUser('이준호', '18회', 3),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTopUser(String name, String count, int rank, {bool crown = false}) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            CircleAvatar(
              radius: rank == 1 ? 36 : 28,
              backgroundColor: Colors.white,
              child: Text(
                name[0],
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Positioned(
              top: -4,
              right: -4,
              child: crown
                  ? Image.asset('lib/assets/crownIcon.png', width: 24, height: 24)
                  : CircleAvatar(
                radius: 10,
                backgroundColor: Colors.black,
                child: Text(
                  '$rank',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(name, style: const TextStyle(color: Colors.white)),
        Text(count, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildUserListTile({required int rank, required String name, required int count}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Text('$rank', style: const TextStyle(color: Colors.black)),
      ),
      title: Text(name, style: const TextStyle(fontFamily: 'Montserrat')),
      subtitle: Text('$count회 당첨'),
    );
  }

  Widget _buildTotalRanking() {
    return const Expanded(
      child: Center(child: Text('총 랭킹 탭 (예정)'),),
    );
  }
}