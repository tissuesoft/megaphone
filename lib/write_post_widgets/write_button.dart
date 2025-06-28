import 'package:flutter/material.dart';

class WriteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isEnabled;

  const WriteButton({
    super.key,
    required this.onPressed,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final Color backgroundColor =
    isEnabled ? const Color(0xFFFF6B35) : const Color(0xFFD9D9D9);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      width: screenWidth,
      height: 56,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextButton(
          onPressed: isEnabled ? onPressed : null,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('게시글 작성하기'),
        ),
      ),
    );
  }
}
