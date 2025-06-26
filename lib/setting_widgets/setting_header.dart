import 'package:flutter/material.dart';

class SettingHeader extends StatelessWidget implements PreferredSizeWidget {
  const SettingHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(53);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea( // ✅ 추가
      bottom: false,
      child: Container(
        width: screenWidth,
        height: 53,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Text(
              '설정',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Color(0xFF333333),
              ),
            ),
            Positioned(
              left: screenWidth * 0.04,
              top: (53 - 44) / 2,
              child: SizedBox(
                width: 34,
                height: 44,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Color(0xFF333333),
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
