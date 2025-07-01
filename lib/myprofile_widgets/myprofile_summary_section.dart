// import 'package:flutter/material.dart';
//
// class MyProfileSummarySection extends StatelessWidget {
//   const MyProfileSummarySection({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Container(
//       width: screenWidth,
//       height: 119,
//       padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         border: Border(
//           bottom: BorderSide(color: Color(0xFFF3F4F6)),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center, // ✅ 가운데 정렬
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // 닉네임
//           const Text(
//             '고확왕',
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.w700,
//               fontSize: 20,
//               color: Color(0xFFFF6B35),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
