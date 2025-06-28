import 'package:flutter/material.dart';

class TipBox extends StatelessWidget {
  const TipBox({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      width: screenWidth,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromRGBO(255, 107, 53, 0.1), Color(0xFFFFEDD5)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 아이콘
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(Icons.lightbulb, color: Color(0xFFFF6B35), size: 16),
          ),
          const SizedBox(width: 8),

          // 텍스트 전체
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // 제목
                Text(
                  '고확 당첨 팁',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 8),

                // 리스트
                Text(
                  '• 짧고 임팩트 있는 메시지가 좋아요를 많이 받아요',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    color: Color(0xFF4B5563),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '• 공감할 수 있는 일상 이야기나 재미있는 드립을 써보세요',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    color: Color(0xFF4B5563),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '• 마감 1분 전까지 좋아요가 가장 많은 글이 당첨돼요',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
