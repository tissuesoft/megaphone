import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:megaphone/screens/otherpeople_profile_screen.dart';

class MegaphoneCard extends StatefulWidget {
  const MegaphoneCard({super.key});

  @override
  State<MegaphoneCard> createState() => _MegaphoneCardState();
}

class _MegaphoneCardState extends State<MegaphoneCard> {
  bool isLiked = false;

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OtherProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 타이틀 & 시간
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/home_megaphone_icon.png',
                    width: 20,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '지금 울리는 고확',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  '11:00',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 본문 텍스트 (전광판 효과)
          SizedBox(
            height: 28,
            width: double.infinity,
            child: Marquee(
              text: '점심시간에 라면 먹는 사람 손들 어봐 푸쵸핸즈업 푸쵸핸즈업 🍜',
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.white,
              ),
              scrollAxis: Axis.horizontal,
              blankSpace: 60.0,
              velocity: 40.0,
              startPadding: 10.0,
              accelerationDuration: const Duration(seconds: 1),
              accelerationCurve: Curves.linear,
              decelerationDuration: const Duration(milliseconds: 500),
              decelerationCurve: Curves.easeOut,
            ),
          ),
          const SizedBox(height: 16),

          // 하단 정보
          Row(
            children: [
              // 좋아요 버튼
              GestureDetector(
                onTap: toggleLike,
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 16,
                      color: isLiked ? Colors.red : Colors.white,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '1,247',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // 프로필 + 이름
              GestureDetector(
                onTap: goToProfile,
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage('assets/kimyongsik.jpg'),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '김고확',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // 고확 배지
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFED7AA),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/megaphoneCountIcon.png',
                      width: 12,
                      height: 12,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '145회',
                      style: TextStyle(
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
        ],
      ),
    );
  }
}
