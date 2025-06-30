import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeFilterBar extends StatefulWidget {
  final DateTime selectedDateTime;
  final Function(DateTime) onTimeSelected;

  const TimeFilterBar({
    super.key,
    required this.selectedDateTime,
    required this.onTimeSelected,
  });

  @override
  State<TimeFilterBar> createState() => _TimeFilterBarState();
}

class _TimeFilterBarState extends State<TimeFilterBar> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startHourlyRefresh();
  }

  void _startHourlyRefresh() {
    // 매 정시마다 setState 호출
    final now = DateTime.now().toUtc().add(const Duration(hours: 9));
    final nextFullHour = DateTime(now.year, now.month, now.day, now.hour + 1);
    final durationUntilNextHour = nextFullHour.difference(now);

    // 최초 한 번 실행 시간까지 기다렸다가 시작
    Future.delayed(durationUntilNextHour, () {
      if (!mounted) return;

      // ✅ 정각 도달 시 다음 시간대 자동 선택
      final newSelected = DateTime.now().toUtc().add(const Duration(hours: 9));
      final nextHour = DateTime(newSelected.year, newSelected.month, newSelected.day, newSelected.hour + 1);
      widget.onTimeSelected(nextHour); // ← HomeScreen 갱신

      // ✅ 이후부터는 매시간 반복
      _timer = Timer.periodic(const Duration(hours: 1), (_) {
        if (!mounted) return;
        final now = DateTime.now().toUtc().add(const Duration(hours: 9));
        final nextHour = DateTime(now.year, now.month, now.day, now.hour + 1);
        widget.onTimeSelected(nextHour); // ← 정시마다 다음 시간 선택
      });
    });
  }

  List<DateTime> _generateNext6Hours() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 9));
    final nextHour = DateTime(now.year, now.month, now.day, now.hour + 1);
    return List.generate(6, (i) => nextHour.add(Duration(hours: i)));
  }

  @override
  void dispose() {
    _timer?.cancel(); // 타이머 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('HH:00');
    final timeList = _generateNext6Hours(); // 매번 build 시 새로 계산

    return Container(
      height: 53,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFF9CA3AF))),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemCount: timeList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final time = timeList[index];
          final isSelected = time == widget.selectedDateTime;

          return GestureDetector(
            onTap: () => widget.onTimeSelected(time),
            child: Container(
              width: 68,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFF6B35) : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              alignment: Alignment.center,
              child: Text(
                formatter.format(time),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
