import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeFilterBar extends StatefulWidget {
  final String selectedTime;
  final Function(String) onTimeSelected;

  const TimeFilterBar({
    super.key,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  State<TimeFilterBar> createState() => _TimeFilterBarState();
}

class _TimeFilterBarState extends State<TimeFilterBar> {
  late final List<String> times;

  @override
  void initState() {
    super.initState();
    times = _generateTimes();
  }

  List<String> _generateTimes() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 9)); // 한국 시간
    final roundedNextHour = DateTime(now.year, now.month, now.day, now.hour + 1);
    final formatter = DateFormat('HH:00');
    return List.generate(6, (i) => formatter.format(roundedNextHour.add(Duration(hours: i))));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFF9CA3AF), width: 1),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemCount: times.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final time = times[index];
          final isSelected = time == widget.selectedTime;

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
                time,
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
