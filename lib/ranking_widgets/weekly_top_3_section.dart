// import 'package:flutter/material.dart';
// import 'package:megaphone/screens/otherpeople_profile_screen.dart';
//
// class WeeklyTop3Section extends StatelessWidget {
//   const WeeklyTop3Section({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 24),
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//       ),
//       child: Column(
//         children: [
//           const Text(
//             '이번 주 고확 랭킹',
//             style: TextStyle(
//               fontFamily: 'Montserrat',
//               fontWeight: FontWeight.w700,
//               fontSize: 18,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 4),
//           const Text(
//             '12월 16일 - 12월 22일',
//             style: TextStyle(
//               fontFamily: 'Montserrat',
//               fontWeight: FontWeight.w400,
//               fontSize: 14,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: const [
//               _TopUserCard(
//                 name: '김민수',
//                 rank: '2',
//                 count: '23회',
//                 imageSize: 64,
//                 badgeColor: Color(0xFFD1D5DB),
//                 borderColor: Color(0xFFD1D5DB),
//                 countGradient: LinearGradient(
//                   colors: [Color(0xFF9A9A9A), Color(0xFFFFFFFF)],
//                 ),
//               ),
//               SizedBox(width: 20),
//               _TopUserCard(
//                 name: '박지연',
//                 rank: '1',
//                 count: '47회',
//                 imageSize: 80,
//                 badgeColor: Color(0xFFFACC15),
//                 borderColor: Color(0xFFFACC15),
//                 isCrown: true,
//                 countGradient: LinearGradient(
//                   colors: [Color(0xFFFFD700), Color(0xFFFF6B6B)],
//                 ),
//               ),
//               SizedBox(width: 20),
//               _TopUserCard(
//                 name: '이준호',
//                 rank: '3',
//                 count: '18회',
//                 imageSize: 64,
//                 badgeColor: Color(0xFFC6610F),
//                 borderColor: Color(0xFFC6610F),
//                 countGradient: LinearGradient(
//                   colors: [Color(0xFFC6610F), Color(0xFFFFA500)],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _TopUserCard extends StatelessWidget {
//   final String name;
//   final String rank;
//   final String count;
//   final double imageSize;
//   final Color badgeColor;
//   final Color borderColor;
//   final bool isCrown;
//   final Gradient countGradient;
//
//   const _TopUserCard({
//     super.key,
//     required this.name,
//     required this.rank,
//     required this.count,
//     required this.imageSize,
//     required this.badgeColor,
//     required this.borderColor,
//     required this.countGradient,
//     this.isCrown = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const OtherProfileScreen(),
//           ),
//         );
//       },
//       child: Column(
//         children: [
//           Stack(
//             clipBehavior: Clip.none,
//             children: [
//               Container(
//                 width: imageSize,
//                 height: imageSize,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color: borderColor, width: 4),
//                   image: const DecorationImage(
//                     image: NetworkImage('https://via.placeholder.com/150'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 right: -8,
//                 top: -8,
//                 child: Container(
//                   width: 32,
//                   height: 32,
//                   decoration: BoxDecoration(
//                     color: badgeColor,
//                     shape: BoxShape.circle,
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     rank,
//                     style: const TextStyle(
//                       fontFamily: 'Poppins',
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               if (isCrown)
//                 Positioned(
//                   right: -12,
//                   top: -12,
//                   child: Container(
//                     width: 40,
//                     height: 40,
//                     decoration: const BoxDecoration(
//                       color: Color(0xFFFACC15),
//                       shape: BoxShape.circle,
//                     ),
//                     alignment: Alignment.center,
//                     child: Icon(
//                       Icons.emoji_events,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             name,
//             style: const TextStyle(
//               fontFamily: 'Poppins',
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               gradient: countGradient,
//               borderRadius: BorderRadius.circular(999),
//             ),
//             child: Text(
//               count,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontFamily: 'Poppins',
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
