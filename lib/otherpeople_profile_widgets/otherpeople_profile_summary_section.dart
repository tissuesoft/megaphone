import 'package:flutter/material.dart';

class OtherPeopleProfileSummarySection extends StatelessWidget {
  const OtherPeopleProfileSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      height: 129,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFF3F4F6)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 프로필 이미지 (단독)
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: Image.asset(
              'assets/kimyongsik.jpg', // 고정 이미지
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          // 닉네임
          const Text(
            '고확왕',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}
