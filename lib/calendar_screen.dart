import 'dart:convert';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'styles.dart';
import 'calendar_cell.dart';
import 'main.dart';
import 'monthly_ball_count_widget.dart';
import 'color_provider.dart';
import 'package:provider/provider.dart';

class CalendarScreen extends StatefulWidget {
  final Function(DateTime) onDaySelected;

  const CalendarScreen({Key? key, required this.onDaySelected}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  List<Map<String, dynamic>> _memos = [];
  late int _selectedYear;
  late int _selectedMonth;
  late ColorProvider colorProvider;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _selectedYear = _focusedDay.year;
    _selectedMonth = _focusedDay.month;
    _loadMemos();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colorProvider = Provider.of<ColorProvider>(context);
  }

  Future<void> _loadMemos() async {
    final String? memosJson = prefs.getString('memos');
    if (memosJson != null) {
      setState(() {
        _memos = (jsonDecode(memosJson) as List)
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      });
    }
  }

  bool isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }

  void _selectYearMonth() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: AppStyles.commonBackgroundColor,  // 배경색 지정
              title: Text('년도와 월 선택', 
                style: TextStyle(
                  fontFamily: AppStyles.fontFamily,
                  color: AppStyles.textColor,  // 텍스트 색상 지정
                )
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<int>(
                    value: _selectedYear,
                    items: List.generate(DateTime.now().year - 2009, (index) => 2010 + index)
                        .map((int year) {
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text('$year년', 
                          style: TextStyle(fontFamily: AppStyles.fontFamily, color: AppStyles.textColor),

                        ),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedYear = newValue;
                          // 선택한 년도가 현재 년도일 경우, 월 선택을 현재 월까지로 제한
                          if (_selectedYear == DateTime.now().year && _selectedMonth > DateTime.now().month) {
                            _selectedMonth = DateTime.now().month;
                          }
                        });
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  DropdownButton<int>(
                    value: _selectedMonth,
                    items: List.generate(
                      _selectedYear == DateTime.now().year ? DateTime.now().month : 12,
                      (index) => index + 1
                    ).map((int month) {
                      return DropdownMenuItem<int>(
                        value: month,
                        child: Text('$month월', 
                          style: TextStyle(fontFamily: AppStyles.fontFamily, color: AppStyles.textColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedMonth = newValue;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('취소', style: TextStyle(fontFamily: AppStyles.fontFamily)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('확인', style: TextStyle(fontFamily: AppStyles.fontFamily)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    this.setState(() {
                      _focusedDay = DateTime(_selectedYear, _selectedMonth);
                    });
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Map<Color, int> _getMonthlyBallCount() {
    final Map<Color, int> ballCount = {
      Colors.red: 0,
      const Color(0xFFFFD700): 0,
      Colors.blue: 0,
      Colors.green: 0,
      const Color.fromARGB(255, 255, 134, 231): 0,
      Colors.purple: 0,
    };
    final startOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final endOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);

    for (var memo in _memos) {
      final memoDate = DateTime.parse(memo['time']);
      if (memoDate.isAfter(startOfMonth) && memoDate.isBefore(endOfMonth)) {
        final color = _getColorFromEmoji(memo['emoji']);
        ballCount[color] = (ballCount[color] ?? 0) + 1;
      }
    }

    return ballCount;
  }

  Color _getColorFromEmoji(String emoji) {
    switch (emoji) {
      case '😠': return Colors.red;
      case '😩': return Colors.red;
      case '😊': return const Color(0xFFFFD700);
      case '😎': return const Color(0xFFFFD700);
      case '😢': return Colors.blue;
      case '😴': return Colors.green;
      case '😐': return Colors.green;
      case '🥰': return const Color.fromARGB(255, 255, 134, 231);
      case '🤔': return Colors.purple;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cellWidth = (MediaQuery.of(context).size.width - 32) / 7;
    final cellHeight = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        20 - 8) / 7;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorProvider.commonBackgroundColor,
        title: Center(
          child: Text(
            "${_focusedDay.year}년, ${_focusedDay.month}월의 기억",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: AppStyles.fontFamily),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: _selectYearMonth,
          ),
        ],
      ),
      body: Container(
        color: colorProvider.commonBackgroundColor, // 통일된 배경색 사용
        child: Stack(
          children: [
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
                Navigator.pop(context);
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
                  color: AppStyles.lightPink,
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
                  MediaQuery.of(context).padding.top) / 7,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: false,
                leftChevronVisible: false,
                rightChevronVisible: false,
                titleTextStyle: TextStyle(fontSize: 0),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  return CalendarCell(
                    day: day,
                    isSelected: false,
                    isToday: false,
                    isFocused: isSameMonth(day, focusedDay),
                    memos: _getMemosForDay(day),
                    cellWidth: cellWidth,
                    cellHeight: cellHeight,
                  );
                },
                selectedBuilder: (context, day, focusedDay) {
                  return CalendarCell(
                    day: day,
                    isSelected: true,
                    isToday: false,
                    isFocused: true,
                    memos: _getMemosForDay(day),
                    cellWidth: cellWidth,
                    cellHeight: cellHeight,
                  );
                },
                todayBuilder: (context, day, focusedDay) {
                  return CalendarCell(
                    day: day,
                    isSelected: false,
                    isToday: true,
                    isFocused: true,
                    memos: _getMemosForDay(day),
                    cellWidth: cellWidth,
                    cellHeight: cellHeight,
                  );
                },
              ),
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: MonthlyBallCountWidget(ballCount: _getMonthlyBallCount()),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getMemosForDay(DateTime day) {
    return _memos.where((memo) {
      final memoDate = DateTime.parse(memo['time']);
      return isSameDay(memoDate, day);
    }).toList();
  }
}
