import 'package:flutter/material.dart';

class MyProfilePostList extends StatelessWidget {
  const MyProfilePostList({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final posts = [
      {
        'date': '2024.06.22 15:40',
        'text': '이번 주말엔 뭐하지? 날씨 좋으면 소풍 가고 싶다 🌿',
        'likes': '98',
        'comments': '20',
      },
      {
        'date': '2024.06.21 19:12',
        'text': '퇴근하고 먹는 김치찌개는 진리...',
        'likes': '154',
        'comments': '37',
      },
      {
        'date': '2024.06.20 08:00',
        'text': '출근길에 듣는 음악 추천해줘!',
        'likes': '67',
        'comments': '12',
      },
    ];

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: posts.length,
      separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF3F4F6)),
      itemBuilder: (context, index) {
        final post = posts[index];
        return Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 날짜 + 아이콘 줄
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
                      const Icon(Icons.favorite, size: 14, color: Color(0xFFEF4444)),
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
                      const Icon(Icons.chat_bubble_outline, size: 14, color: Color(0xFF000000)),
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
        );
      },
    );
  }
}
