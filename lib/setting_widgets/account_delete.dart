import 'dart:ui';
import 'package:flutter/material.dart';

void showWithdrawDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.3), // 어두운 배경
    builder: (_) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // 🔹 블러 처리
        child: Center(
          child: Container(
            width: 320,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔺 경고 아이콘 영역
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEE2E2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.warning_amber_rounded,
                      color: Color(0xFFEF4444), size: 32),
                ),
                const SizedBox(height: 24),

                // 🔹 타이틀
                const Text(
                  '정말로 탈퇴하시겠습니까?',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 12),

                // 🔸 설명 텍스트
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    '회원 탈퇴 시 모든 데이터가 삭제되며\n복구할 수 없습니다.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF4B5563),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 24),

                // ✅ 탈퇴/취소 버튼
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: 탈퇴 로직 실행
                            Navigator.of(context).pop(); // 닫기
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF4444),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            '탈퇴하기',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFF3F4F6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            '취소',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
