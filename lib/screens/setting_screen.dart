import 'package:flutter/material.dart';
import 'package:megaphone/setting_widgets/setting_header.dart';
import 'package:megaphone/setting_widgets/setting_profile_section.dart';
import 'package:megaphone/setting_widgets/setting_notification_section.dart';
import 'package:megaphone/setting_widgets/setting_info_section.dart';
import 'package:megaphone/setting_widgets/setting_logout_section.dart';
import 'package:megaphone/screens/bottom_nav_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BottomNavScreen(initialIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const SettingHeader(),
      body: ListView(
        children: const [
          SettingProfileSection(),
          SettingNotificationSection(),
          SettingInfoSection(),
          SettingLogoutSection(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFFF6B35),
        unselectedItemColor: const Color(0xFF9CA3AF),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: '랭킹',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '프로필',
          ),
        ],
      ),
    );
  }
}
