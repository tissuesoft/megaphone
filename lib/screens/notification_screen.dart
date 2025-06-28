import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '알림',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              '모두 읽음',
              style: TextStyle(
                color: Color(0xFFFF6B35),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _NotificationItem(
            icon: Icons.emoji_events,
            iconColor: Color(0xFFFF6B35),
            title: '🎉 고확 당첨!',
            content:
                '"오늘 점심 뭐 먹지? 고민하다가 배고파 죽겠다 ㅠㅠ"\n축하합니다! 12:00 고확에 당첨되셨습니다🔥',
            time: '방금 전',
            badge: '3회',
            badgeColor: Color(0xFFFFE6D6),
            badgeTextColor: Color(0xFFFF6B35),
            isBold: true,
          ),
          _NotificationItem(
            icon: Icons.favorite,
            iconColor: Color(0xFFFF4D4F),
            title: '공감 알림',
            content: '"민수님"이 회원님의 게시글에 공감했습니다',
            time: '5분 전',
          ),
          _NotificationItem(
            icon: Icons.access_time,
            iconColor: Color(0xFF22C55E),
            title: '고확 시간 알림',
            content: '13:00 고확까지 30분 남았습니다! 지금 참여하세요 🚀',
            time: '30분 전',
          ),
          _NotificationItem(
            icon: Icons.emoji_events,
            iconColor: Color(0xFFFF6B35),
            title: '고확 당첨 발표',
            content: '11:30 고확 당첨자가 발표되었습니다!',
            time: '1시간 전',
          ),
          _NotificationItem(
            icon: Icons.access_time,
            iconColor: Color(0xFF22C55E),
            title: '고확 시간 알림',
            content: '13:00 고확까지 30분 남았습니다! 지금 참여하세요 🚀',
            time: '30분 전',
          ),
          _NotificationItem(
            icon: Icons.favorite,
            iconColor: Color(0xFFFF4D4F),
            title: '공감 알림',
            content: '"하늘님", "바다님" 외 5명이 공감했습니다',
            time: '3시간 전',
          ),
          _NotificationItem(
            icon: Icons.access_time,
            iconColor: Color(0xFF22C55E),
            title: '고확 시간 알림',
            content: '18:00 고확 마감 10분 전입니다! 마지막 기회를 놓치지 마세요 🥳',
            time: '어제',
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String content;
  final String time;
  final String? badge;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final bool isBold;

  const _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.content,
    required this.time,
    this.badge,
    this.badgeColor,
    this.badgeTextColor,
    this.isBold = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF2F2F2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.1),
            child: Icon(icon, color: iconColor, size: 22),
            radius: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                        fontSize: 15,
                        color: isBold
                            ? const Color(0xFFFF6B35)
                            : const Color(0xFF222222),
                      ),
                    ),
                    if (badge != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor ?? const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          badge!,
                          style: TextStyle(
                            color: badgeTextColor ?? const Color(0xFF222222),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: const TextStyle(
                    color: Color(0xFF222222),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
