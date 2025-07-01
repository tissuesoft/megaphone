import 'package:flutter/material.dart';

class OtherPeopleProfileHeader extends StatelessWidget implements PreferredSizeWidget {
  final String userId;

  const OtherPeopleProfileHeader({
    super.key,
    required this.userId,
  });

  @override
  Size get preferredSize => const Size.fromHeight(69);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      bottom: false,
      child: Container(
        height: 69,
        width: screenWidth,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 가운데 "고확왕 user_id 프로필"
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: userId,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xFFFF6B35), // ✔️ 강조 색상
                    ),
                  ),
                  const TextSpan(
                    text: ' 프로필',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ),

            // 왼쪽 뒤로가기 버튼
            Positioned(
              left: screenWidth * 0.04, // 약 16px
              top: (69 - 44) / 2,
              child: SizedBox(
                width: 34,
                height: 44,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Color(0xFF4B5563),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
