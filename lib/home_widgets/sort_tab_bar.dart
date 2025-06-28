import 'package:flutter/material.dart';

class SortTabBar extends StatelessWidget {
  final String selectedTab;
  final void Function(String) onTabChanged;

  const SortTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFF9CA3AF), width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildTabButton('latest', '최신순'),
          _buildTabButton('liked', '공감순'),
        ],
      ),
    );
  }

  Widget _buildTabButton(String value, String label) {
    final isSelected = selectedTab == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(value),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFFFF6B35) : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color: isSelected ? const Color(0xFFFF6B35) : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
