import 'package:flutter/material.dart';

class SettingNotificationSection extends StatefulWidget {
  const SettingNotificationSection({super.key});

  @override
  State<SettingNotificationSection> createState() => _SettingNotificationSectionState();
}

class _SettingNotificationSectionState extends State<SettingNotificationSection> {
  bool isPushEnabled = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "알림" 텍스트
          const Text(
            '알림',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),

          // 푸시 알림 항목
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.notifications_none, size: 20, color: Color(0xFF333333)),
                  SizedBox(width: 12),
                  Text(
                    '푸시 알림',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
              Switch(
                value: isPushEnabled,
                onChanged: (value) {
                  setState(() {
                    isPushEnabled = value;
                  });
                },
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFFFF6B35),
                inactiveTrackColor: const Color(0xFFCCCCCC),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
