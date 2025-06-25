import 'package:flutter/material.dart';
import 'package:megaphone/otherpeople_profile_widgets/otherpeople_profile_header.dart';

class OtherProfileScreen extends StatelessWidget {
  final String nickname;
  final String imageUrl;
  final String description;

  const OtherProfileScreen({
    super.key,
    required this.nickname,
    required this.imageUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const OtherPeopleProfileHeader(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06, vertical: 24),
        child: Column(
          children: [
            // 나머지 UI는 계속 여기에 추가
          ],
        ),
      ),
    );
  }
}
