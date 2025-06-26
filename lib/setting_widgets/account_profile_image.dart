import 'package:flutter/material.dart';

class ProfileImageSection extends StatelessWidget {
  const ProfileImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 147,
      width: screenWidth,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 프로필 이미지
          Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE5E7EB),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/kimyongsik.jpg', // 실제 이미지 경로로 수정
                width: 96,
                height: 96,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 카메라 버튼
          Positioned(
            right: screenWidth / 2 - 96 / 2 + 32,
            bottom: 10,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 4),
                    blurRadius: 6,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 10),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                onPressed: () {
                  // TODO: 프로필 변경 기능
                },
              ),
            ),
          ),

          // 설명 텍스트
          const Positioned(
            bottom: -25,
            child: Text(
              '프로필 사진을 변경하려면 카메라 아이콘을 터치하세요',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
