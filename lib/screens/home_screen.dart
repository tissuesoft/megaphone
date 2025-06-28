import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase import 추가
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
  String selectedTab = 'latest'; // 'latest' 또는 'liked'
  List<dynamic>? boardList;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBoardList();
  }

  Future<void> fetchBoardList() async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('Board')
        .select(
          '*, Users!inner(*)',
        ) // Board의 모든 컬럼과, Users 테이블의 모든 컬럼을 user_id로 조인
        .limit(20);
    print('Fetched board list: $response');
    setState(() {
      boardList = response;
      isLoading = false;
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

      // ✅ 글쓰기 버튼 → 작성화면 이동
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WritePostScreen()),
          );
        },
        backgroundColor: const Color(0xFFFF6B35),
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(Icons.edit, color: Colors.white),
      ),

      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const HomeHeader(),
                    const MegaphoneCard(),
                    const TimeFilterBar(),
                    SortTabBar(
                      selectedTab: selectedTab,
                      onTabChanged: onTabSelected,
                    ),
                    // boardList 데이터를 활용하려면 아래에 위젯 추가
                    if (selectedTab == 'latest')
                      // boardList가 null이 아니고, 데이터가 있을 때만 리스트로 출력
                      if (boardList != null && boardList!.isNotEmpty)
                        Column(
                          children: boardList!.map((item) {
                            final user = item['Users'] ?? {};
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    user['user_image'] ?? '',
                                  ),
                                  radius: 24,
                                ),
                                title: Text(
                                  item['title'] ?? '제목 없음',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user['user_nickname'] ?? '닉네임 없음'),
                                    const SizedBox(height: 4),
                                    Text(
                                      '좋아요: ${item['like'] ?? 0}   '
                                      '고확승리: ${item['megaphone_win'] ?? 0}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '고확시간: ${item['megaphone_time'] ?? ''}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  (item['created_at'] ?? '')
                                      .toString()
                                      .substring(0, 10),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.all(32),
                          child: Text('게시글이 없습니다.'),
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
