//총 랭킹에서 4등부터 100등까지
import 'package:flutter/material.dart';

class TotalRankingList extends StatelessWidget {
  const TotalRankingList({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      {
        'rank': '4',
        'name': '최드립',
        'badge': '134회',
        'image': 'lib/assets/crownIcon.png',
      },
      {
        'rank': '5',
        'name': '정알림',
        'badge': '20회',
        'image': 'assets/images/user5.png',
      },
      {
        'rank': '6',
        'name': '홍메시지',
        'badge': '15회',
        'image': 'assets/images/user6.png',
      },
      {
        'rank': '7',
        'name': '홍메시지',
        'badge': '1회',
        'image': 'assets/images/user6.png',
      },
    ];

    return Column(
      children: users.map((user) => _buildRankingItem(context, user)).toList(),
    );
  }

  Widget _buildRankingItem(BuildContext context, Map<String, String> user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 32,
            child: Text(
              user['rank']!,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF9CA3AF),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(user['image']!),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user['name']!,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFED7AA),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'lib/assets/megaphoneCountIcon.png',
                            width: 12,
                            height: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            user['badge']!,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF9A3412),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // count 생략됨
              ],
            ),
          ),
        ],
      ),
    );
  }
}
