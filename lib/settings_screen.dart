import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'styles.dart';
import 'main.dart';
import 'color_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '1.0.0';

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    final colorProvider = Provider.of<ColorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('설정', style: AppStyles.headerStyle),
        backgroundColor: AppStyles.appBarBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppStyles.textColor),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('전체 정보 초기화', style: AppStyles.memoTextStyle),
            onTap: _resetAllData,
          ),
          ListTile(
            title: Text('앱 버전', style: AppStyles.memoTextStyle),
            subtitle: Text(_appVersion, style: AppStyles.memoTimeStyle),
          ),
          // 테마 색 설정 추가
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('테마 색 설정', style: AppStyles.headerStyle),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildColorOption(AppStyles.lightPink, colorProvider),
              _buildColorOption(const Color.fromARGB(255, 193, 247, 195), colorProvider),
              _buildColorOption(const Color.fromARGB(255, 184, 228, 242), colorProvider),
              _buildColorOption(const Color.fromARGB(255, 255, 255, 153), colorProvider),
            ],
          ),
          // ListTile(
          //   title: Text('배경색 설정', style: AppStyles.memoTextStyle),
          //   onTap: _showBackgroundColorPicker,
          // ),

        ],
      ),
    );
  }

  void _resetAllData() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('전체 정보 초기화', style: TextStyle(fontFamily: "Tenada", color: Colors.black)),
          content: Text('모든 데이터가 삭제됩니다. 계속하시겠습니까?', style: TextStyle(fontFamily: "Tenada")),
          actions: <Widget>[
            TextButton(
              child: Text('취소', style: TextStyle(fontFamily: "Tenada", color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('확인', style: TextStyle(fontFamily: "Tenada", color: Colors.black)),
              onPressed: () async {
                await prefs.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



  void _showBackgroundColorPicker() {
    // 여기에 배경색 선택 로직을 구현하세요
    // 예: 색상 선택 다이얼로그를 표시하고 선택된 색상을 저장
  }

  Widget _buildColorOption(Color color, ColorProvider colorProvider) {
    bool isSelected = colorProvider.memoBubbleColor == color; // 선택된 색상 확인

    return GestureDetector(
      onTap: () => colorProvider.changeColor(color),
      child: Container(
        decoration: BoxDecoration(  
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.black54, width: 2) : null, // 음각 효과
        ),
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: isSelected
            ? Icon(Icons.check, color: Colors.black) // 선택된 경우 체크 아이콘 표시
            : null,
      ),
    );
  }
}
