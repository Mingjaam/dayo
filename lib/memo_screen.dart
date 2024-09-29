import 'package:flutter/material.dart';
import 'calendar_screen.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'main.dart';
import 'styles.dart';

class MemoScreen extends StatefulWidget {
  const MemoScreen({Key? key}) : super(key: key);

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  List<Map<String, dynamic>> _memos = [];
  final TextEditingController _textController = TextEditingController();
  bool _isEmojiPickerVisible = false;
  String _selectedEmoji = '';
  final List<String> _moodEmojis = ['😊', '😄', '😍', '🤔', '😢', '😠', '😴', '😎'];
  bool _isSendButtonEnabled = false;
  int _memoLimit = 12;
  int _todayMemoCount = 0;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_updateSendButtonState);
    _loadMemos();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadMemos() async {
    final String? memosJson = prefs.getString('memos');
    if (memosJson != null) {
      setState(() {
        _memos = (jsonDecode(memosJson) as List)
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
        _updateTodayMemoCount();
      });
    }
  }

  void _updateTodayMemoCount() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _todayMemoCount = _memos.where((memo) {
      final memoDate = DateTime.parse(memo['time']);
      return memoDate.isAtSameMomentAs(today) || memoDate.isAfter(today);
    }).length;
  }

  Future<void> _saveMemos() async {
    await prefs.setString('memos', jsonEncode(_memos));
  }

  void _updateSendButtonState() {
    setState(() {
      _isSendButtonEnabled = _textController.text.isNotEmpty;
    });
  }

  void _addMemo(String text) {
    if (_todayMemoCount < _memoLimit) {
      setState(() {
        _memos.add({
          'text': text,
          'time': DateTime.now().toIso8601String(),
          'emoji': _selectedEmoji.isEmpty ? '😀' : _selectedEmoji,
        });
        _todayMemoCount++;
      });
      _saveMemos();
      _textController.clear();
      _selectedEmoji = '';
      _updateSendButtonState();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오늘의 메모 한도에 도달했습니다.')),
      );
    }
  }

  Future<void> _deleteMemo(int index) async {
    final deletedMemo = _memos[index];
    final deletedMemoDate = DateTime.parse(deletedMemo['time']);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    setState(() {
      _memos.removeAt(index);
      if (deletedMemoDate.isAtSameMomentAs(today) || deletedMemoDate.isAfter(today)) {
        _todayMemoCount--;
      }
    });
    await _saveMemos();
  }

  void _toggleEmojiPicker() {
    setState(() {
      _isEmojiPickerVisible = !_isEmojiPickerVisible;
    });
  }

  void _showEmojiDialog() {
    final List<String> emojis = ['🥰', '😊', '😎', '🤔', '😐', '😴', '😢', '😩', '😠'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppStyles.primaryColor,
          child: Container(
            decoration: BoxDecoration(
              color: AppStyles.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            width: 300,
            height: 340,
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '이모티콘 선택',
                  style: AppStyles.headerStyle,
                ),
                SizedBox(height: 12),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: emojis.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedEmoji = emojis[index];
                          });
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppStyles.accentColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              emojis[index],
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateHeader(DateTime date) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      alignment: Alignment.centerLeft,
      child: Text(
        DateFormat('yyyy년 MM월 dd일').format(date),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppStyles.secondaryTextColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayString = DateFormat('yyyy년 MM월 dd일').format(now);

    // 메모를 날짜별로 그룹화
    final groupedMemos = groupMemosByDate(_memos);

    return Scaffold(
      appBar: AppBar(
        title: Text('DayO', style: AppStyles.headerStyle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: AppStyles.textColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CalendarScreen(
                    onDaySelected: (selectedDay) {
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
          ),
        ],
        // bottom 속성 제거
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ListView(
                reverse: true,
                children: groupedMemos.entries.map((entry) {
                  final date = entry.key;
                  final memos = entry.value;
                  return Column(
                    children: [
                      _buildDateHeader(date),
                      ...memos.map((memo) => _buildMemoItem(memo)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          Divider(
            color: AppStyles.borderColor,
            thickness: 1,
            height: 1,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _showEmojiDialog();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text(_selectedEmoji.isEmpty ? '😀' : _selectedEmoji, style: TextStyle(fontSize: 24)),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppStyles.inputBackgroundColor,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: TextField(
                        controller: _textController,
                        autofocus: false,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: '기억을 적어봐요.',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: AppStyles.secondaryTextColor),
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        style: TextStyle(color: AppStyles.textColor),
                        onChanged: (text) {
                          _updateSendButtonState();
                        },
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        if (_isSendButtonEnabled && _textController.text.isNotEmpty) {
                          _addMemo(_textController.text);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.send,
                          color: _isSendButtonEnabled ? AppStyles.accentColor : AppStyles.secondaryTextColor,
                        ),
                      ),
                    ),
                    Text(
                      '$_todayMemoCount/$_memoLimit',
                      style: TextStyle(fontSize: 10, color: AppStyles.secondaryTextColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildMemoItem(Map<String, dynamic> memo) {
    final memoDate = DateTime.parse(memo['time']);
    return Dismissible(
      key: Key(memo['time']),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: AppStyles.primaryColor,
              title: Text('삭제', style: TextStyle(color: AppStyles.textColor)),
              content: Text('이 기억을 삭제 하시겠습니까? \n당신의 머리속에서 사라지진 않습니다.', style: TextStyle(color: AppStyles.textColor)),
              actions: <Widget>[
                TextButton(
                  child: Text('취소', style: TextStyle(color: AppStyles.textColor)),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text('삭제', style: TextStyle(color: AppStyles.textColor)),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        _deleteMemo(_memos.indexOf(memo));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Container(
              decoration: AppStyles.memoBubbleDecoration,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(memo['emoji'], style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('HH:mm').format(memoDate),
                        style: AppStyles.memoTimeStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(memo['text'], style: AppStyles.memoTextStyle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<DateTime, List<Map<String, dynamic>>> groupMemosByDate(List<Map<String, dynamic>> memos) {
    final groupedMemos = <DateTime, List<Map<String, dynamic>>>{};
    for (final memo in memos) {
      final memoDate = DateTime.parse(memo['time']);
      final dateKey = DateTime(memoDate.year, memoDate.month, memoDate.day);
      if (!groupedMemos.containsKey(dateKey)) {
        groupedMemos[dateKey] = [];
      }
      groupedMemos[dateKey]!.add(memo);
    }
    return groupedMemos;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}