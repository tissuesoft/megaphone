import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          '프로필 화면',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
