import 'package:flutter/material.dart';

class WritePostHeader extends StatelessWidget {
  const WritePostHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      height: 69,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: Stack(
        children: [
          // 뒤로가기 버튼
          Positioned(
            left: screenWidth * 0.02,
            top: 12,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF374151)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          // 가운데 제목
          Positioned(
            top: 18.8,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '게시글 작성',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                  height: 1.55, // 28 / 18
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
