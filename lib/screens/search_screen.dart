import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 검색바
            Container(
              height: 73,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  // 뒤로가기 버튼
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF374151)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 7.75),

                  // 검색창
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.search, size: 16, color: Color(0xFF9CA3AF)),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: '사용자 검색',
                                hintStyle: TextStyle(
                                  color: Color(0xFF9CA3AF), // 회색
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 아래 나머지 컨텐츠 영역
            const Expanded(
              child: Center(
                child: Text(
                  '여기에 검색 결과가 표시됩니다.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
