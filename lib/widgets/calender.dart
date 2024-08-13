import 'package:flutter/material.dart';
import 'package:streak_counters/models/enums/streak_interval.dart';
import '../models/count.dart';

class Calender extends StatefulWidget {
  final List<Count> counts;

  Calender({
    required this.counts,
  });

  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final daysInMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;
    final firstDayOfWeek = firstDayOfMonth.weekday;
    final totalDays = daysInMonth + firstDayOfWeek - 1;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _previousMonth,
            ),
            Text(
              '${_selectedMonth.year}-${_selectedMonth.month.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 20),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: _nextMonth,
            ),
          ],
        ),
        SizedBox(
          height: 250, // Set a fixed height for the calendar
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, // 7 days in a week
            ),
            itemCount: totalDays,
            itemBuilder: (context, index) {
              final date = firstDayOfMonth.add(Duration(days: index - firstDayOfWeek + 1));
              final isCounted = widget.counts.any((count) => count.isOn(date, StreakInterval.daily));

              return Opacity(
                opacity: date.month == _selectedMonth.month ? 1 : .5, // Adjust the opacity value as needed
                child: Container(
                  margin: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    color: isCounted ? Colors.purple[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        color: isCounted ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}