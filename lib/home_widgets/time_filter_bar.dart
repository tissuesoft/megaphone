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
  late final List<DateTime> timeList;

  @override
  void initState() {
    super.initState();
    timeList = _generateNext6Hours();
  }

  List<DateTime> _generateNext6Hours() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 9));
    final nextHour = DateTime(now.year, now.month, now.day, now.hour + 1);
    return List.generate(6, (i) => nextHour.add(Duration(hours: i)));
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('HH:00');

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
