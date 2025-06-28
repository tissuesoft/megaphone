import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeFilterBar extends StatefulWidget {
  const TimeFilterBar({super.key});

  @override
  State<TimeFilterBar> createState() => _TimeFilterBarState();
}

class _TimeFilterBarState extends State<TimeFilterBar> {
  late final List<String> times;
  late String selectedTime;

  @override
  void initState() {
    super.initState();
    times = _generateTimes();
    selectedTime = times.first;
  }

  List<String> _generateTimes() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 10)); // ✅ KST 기준
    final roundedNow = DateTime(now.year, now.month, now.day, now.hour);
    final formatter = DateFormat('HH:00');
    return List.generate(7, (i) => formatter.format(roundedNow.add(Duration(hours: i))));
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
          final isSelected = time == selectedTime;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedTime = time;
              });
            },
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
