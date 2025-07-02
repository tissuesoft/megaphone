// //랭킹 화면
// import 'package:flutter/material.dart';
// import 'package:megaphone/ranking_widgets/weekly_top_3_section.dart';
// import 'package:megaphone/ranking_widgets/total_top_3_section.dart';
// import 'package:megaphone/ranking_widgets/weekly_ranking_list.dart';
// import 'package:megaphone/ranking_widgets/total_ranking_list.dart';
// import 'package:megaphone/screens/search_screen.dart';
//
// class RankingScreen extends StatefulWidget {
//   const RankingScreen({super.key});
//
//   @override
//   State<RankingScreen> createState() => _RankingScreenState();
// }
//
// class _RankingScreenState extends State<RankingScreen> {
//   int selectedTabIndex = 0; // 0: 총 랭킹, 1: 주간 랭킹
//   int selectedBottomIndex = 1; // 0: 홈, 1: 랭킹, 2: 프로필
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: Colors.white, // 상태바 포함 전체 배경 흰색
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ✅ 상단 헤더
//             Container(
//               width: screenWidth,
//               height: 65,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 border: Border(
//                   bottom: BorderSide(color: Color(0xFFE5E7EB)),
//                 ),
//               ),
//               child: Stack(
//                 children: [
//                   const Center(
//                     child: Text(
//                       '랭킹',
//                       style: TextStyle(
//                         fontFamily: 'Montserrat',
//                         fontWeight: FontWeight.w700,
//                         fontSize: 20,
//                         height: 1.4,
//                         color: Color(0xFF2D3748),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     right: 16,
//                     top: 12,
//                     child: SizedBox(
//                       width: 32,
//                       height: 40,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const SearchScreen(),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFFF3F4F6),
//                           shape: const CircleBorder(),
//                           padding: EdgeInsets.zero,
//                           elevation: 0,
//                         ),
//                         child: const Icon(
//                           Icons.search,
//                           size: 20,
//                           color: Color(0xFF4B5563),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // ✅ 탭 영역
//             Container(
//               width: screenWidth,
//               height: 59,
//               decoration: const BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(color: Color(0xFFE5E7EB)),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   // 🔸 총 랭킹 탭
//                   Expanded(
//                     child: InkWell(
//                       onTap: () {
//                         setState(() {
//                           selectedTabIndex = 0;
//                         });
//                       },
//                       child: Container(
//                         color: selectedTabIndex == 0
//                             ? const Color(0xFFFFFAF5)
//                             : Colors.white,
//                         child: Stack(
//                           children: [
//                             Center(
//                               child: Text(
//                                 '총 랭킹',
//                                 style: TextStyle(
//                                   fontFamily: 'Montserrat',
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: selectedTabIndex == 0
//                                       ? const Color(0xFFFF6B00)
//                                       : const Color(0xFF9CA3AF),
//                                 ),
//                               ),
//                             ),
//                             if (selectedTabIndex == 0)
//                               const Align(
//                                 alignment: Alignment.bottomCenter,
//                                 child: SizedBox(
//                                   height: 3,
//                                   child: ColoredBox(
//                                     color: Color(0xFFFF6B00),
//                                     child: SizedBox.expand(),
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   // 🔸 주간 랭킹 탭
//                   Expanded(
//                     child: InkWell(
//                       onTap: () {
//                         setState(() {
//                           selectedTabIndex = 1;
//                         });
//                       },
//                       child: Container(
//                         color: selectedTabIndex == 1
//                             ? const Color(0xFFFFFAF5)
//                             : Colors.white,
//                         child: Stack(
//                           children: [
//                             Center(
//                               child: Text(
//                                 '주간 랭킹',
//                                 style: TextStyle(
//                                   fontFamily: 'Montserrat',
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: selectedTabIndex == 1
//                                       ? const Color(0xFFFF6B00)
//                                       : const Color(0xFF9CA3AF),
//                                 ),
//                               ),
//                             ),
//                             if (selectedTabIndex == 1)
//                               const Align(
//                                 alignment: Alignment.bottomCenter,
//                                 child: SizedBox(
//                                   height: 3,
//                                   child: ColoredBox(
//                                     color: Color(0xFFFF6B00),
//                                     child: SizedBox.expand(),
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // ✅ 탭에 따른 콘텐츠
//             Expanded(
//               child: selectedTabIndex == 0
//                   ? _buildTotalRankingView()
//                   : _buildWeeklyRankingView(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // 총 랭킹 콘텐츠
//   Widget _buildTotalRankingView() {
//     return SingleChildScrollView(
//       child: Column(
//         children: const [
//           TotalTop3Section(),
//           TotalRankingList(),
//         ],
//       ),
//     );
//   }
//
//   // 주간 랭킹 콘텐츠
//   Widget _buildWeeklyRankingView() {
//     return SingleChildScrollView(
//       child: Column(
//         children: const [
//           WeeklyTop3Section(),
//           WeeklyRankingList(),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          '준비중...',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9CA3AF),
          ),
        ),
      ),
    );
  }
}
