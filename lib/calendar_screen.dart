import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'styles.dart';
class CalendarScreen extends StatefulWidget {
  final Function(DateTime) onDaySelected;

  const CalendarScreen({Key? key, required this.onDaySelected}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
  }

  bool isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.07),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  "DayO",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Expanded(child: SizedBox()),
                Text(
                  "${_focusedDay.year}년, ${_focusedDay.month}월의 기억",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              widget.onDaySelected(selectedDay);
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              cellMargin: EdgeInsets.zero,
              cellPadding: EdgeInsets.zero,
              todayDecoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
            daysOfWeekHeight: 20,
            sixWeekMonthsEnforced: true,
            rowHeight: (MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top -
                20 - 8) / 7,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: false,
              leftChevronVisible: false,
              rightChevronVisible: false,
              titleTextStyle: TextStyle(fontSize: 0),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return _buildCalendarCell(day, false, false, isFocused: true);
              },
              selectedBuilder: (context, day, focusedDay) {
                return _buildCalendarCell(day, true, false, isFocused: true);
              },
              todayBuilder: (context, day, focusedDay) {
                return _buildCalendarCell(day, false, true, isFocused: true);
              },
              // outsideBuilder 제거
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCell(DateTime day, bool isSelected, bool isToday, {required bool isFocused}) {
    Color dayColor;
    if (!isFocused) {
      dayColor = Colors.grey[400]!;
    } else if (isSelected) {
      dayColor = Colors.white;
    } else if (isToday) {
      dayColor = Colors.black;
    } else {
      dayColor = Colors.black87;
    }

    return Container(
      margin: EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: isSelected ? AppStyles.memoBubbleColor : (isToday ? Colors.grey[300] : null),
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            '${day.day}',
            style: TextStyle(
              color: dayColor,
              fontWeight: isSelected || isToday ? FontWeight.bold : null,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}