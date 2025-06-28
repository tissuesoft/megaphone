import 'package:flutter/material.dart';
import 'package:megaphone/screens/post_screen.dart'; // ✅ 추가

class OtherPeopleProfileHighlightList extends StatelessWidget {
  const OtherPeopleProfileHighlightList({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // 더미 데이터 리스트
    final posts = [
      {
        'date': '2024.06.23 12:00',
        'text': '오늘 점심 뭐 먹지? 고민하는 시간에 배고파 죽겠다 ㅠㅠ',
        'likes': '156',
        'comments': '42',
      },
      {
        'date': '2024.06.23 12:00',
        'text': '금요일 저녁인데 집에서 넷플릭스 보는 나... 이게 진짜 행복이야',
        'likes': '156',
        'comments': '42',
      },
      {
        'date': '2024.06.23 12:00',
        'text': '비 오는 날 카페에서 아아 마시면서 창밖 보기... 힐링 그 자체',
        'likes': '156',
        'comments': '42',
      },
      {
        'date': '2024.06.23 12:00',
        'text': '비 오는 날 카페에서 아아 마시면서 창밖 보기... 힐링 그 자체',
        'likes': '156',
        'comments': '42',
      },
    ];

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: posts.length,
      separatorBuilder: (_, __) =>
      const Divider(height: 1, color: Color(0xFFF3F4F6)),
      itemBuilder: (context, index) {
        final post = posts[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PostScreen()), // ✅ 클릭 시 이동
            );
          },
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 날짜 및 아이콘 줄
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      post['date']!,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF111827),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.favorite,
                            size: 14, color: Color(0xFFEF4444)),
                        const SizedBox(width: 4),
                        Text(
                          post['likes']!,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.chat_bubble_outline,
                            size: 14, color: Color(0xFF000000)),
                        const SizedBox(width: 4),
                        Text(
                          post['comments']!,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  post['text']!,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF1F2937),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
