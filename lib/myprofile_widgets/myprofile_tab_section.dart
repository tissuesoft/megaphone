import 'package:flutter/material.dart';

class MyProfileTabSection extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const MyProfileTabSection({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFF3F4F6)),
        ),
      ),
      child: Row(
        children: [
          // 고확 기록 탭
          _buildTabButton(
            label: '고확 기록',
            isSelected: selectedIndex == 0,
            onTap: () => onTabSelected(0),
          ),
          // 게시글 탭
          _buildTabButton(
            label: '게시글',
            isSelected: selectedIndex == 1,
            onTap: () => onTabSelected(1),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFFFF6B35) : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFF6B7280),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
