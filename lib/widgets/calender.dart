import 'package:flutter/material.dart';
import 'package:streak_counters/models/enums/streak_interval.dart';
import '../models/count.dart';

class Calender extends StatefulWidget {
  final List<Count> counts;
  final StreakInterval interval;

  Calender({
    required this.counts,
    required this.interval,
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
    final firstDayOfMonth =
        DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final daysInMonth =
        DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;
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
        Container(
          decoration: BoxDecoration(
            color: (widget.interval == StreakInterval.monthly ||
                        widget.interval == StreakInterval.yearly) &&
                    widget.counts.any(
                      (count) => count.isOn(firstDayOfMonth, widget.interval),
                    )
                ? Colors.green[800]
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: SizedBox(
            height: 250, // Set a fixed height for the calendar
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, // 7 days in a week
              ),
              itemCount: totalDays,
              itemBuilder: (context, index) {
                final date = firstDayOfMonth
                    .add(Duration(days: index - firstDayOfWeek + 1));
                final isCounted = widget.counts
                    .any((count) => count.isOn(date, StreakInterval.daily));
                final isIn = widget.counts.any((count) => count.isOn(
                    date.subtract(Duration(days: -1)), widget.interval));

                return Container(
                    margin: EdgeInsets.only(bottom: 1, top: 1),
                    decoration: BoxDecoration(
                      color: isIn && widget.interval == StreakInterval.weekly
                          ? Colors.green[800]
                          : Colors.transparent,
                      borderRadius: widget.interval == StreakInterval.weekly
                          ? BorderRadius.horizontal(
                              left: date.weekday == 1
                                  ? Radius.circular(4)
                                  : Radius.circular(0),
                              right: date.weekday == 7 ||
                                      (date.day == daysInMonth &&
                                          date.month == _selectedMonth.month)
                                  ? Radius.circular(4)
                                  : Radius.circular(0))
                          : null,
                    ),
                    child: Opacity(
                      opacity: date.month == _selectedMonth.month ? 1 : .4,
                      // Adjust the opacity value as needed
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 3, right: 3, bottom: 2, top: 2),
                        decoration: BoxDecoration(
                          color:
                              isCounted ? Colors.purple[800] : Colors.grey[800],
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Center(
                          child: Text(
                            '${date.day}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ));
              },
            ),
          ),
        )
      ],
    );
  }
}
