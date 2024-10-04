import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'styles.dart';
import 'main.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '1.0.0';
  bool _isLoggedIn = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadUserInfo();
  }

  void _checkLoginStatus() async {
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  void _loadUserInfo() async {
    if (_isLoggedIn) {
      try {
        User user = await UserApi.instance.me();
        setState(() {
          _user = user;
        });
      } catch (error) {
        print('사용자 정보 로드 실패: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정', style: AppStyles.headerStyle),
        backgroundColor: AppStyles.appBarBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppStyles.textColor),
      ),
      body: ListView(
        children: [
          if (!_isLoggedIn)
            ListTile(
              title: Text('로그인', style: AppStyles.memoTextStyle),
              onTap: _navigateToLogin,
            ),
          if (_isLoggedIn)
            ListTile(
              title: Text('로그아웃', style: AppStyles.memoTextStyle),
              onTap: _logout,
            ),
          ListTile(
            title: Text('전체 정보 초기화', style: AppStyles.memoTextStyle),
            onTap: _resetAllData,
          ),
          ListTile(
            title: Text('앱 버전', style: AppStyles.memoTextStyle),
            subtitle: Text(_appVersion, style: AppStyles.memoTimeStyle),
          ),
          ListTile(
            title: Text('테마 색 설정', style: AppStyles.memoTextStyle),
            onTap: _showColorPicker,
          ),
          ListTile(
            title: Text('배경색 설정', style: AppStyles.memoTextStyle),
            onTap: _showBackgroundColorPicker,
          ),
          if (_isLoggedIn && _user != null)
            ListTile(
              title: Text('로그인 정보', style: AppStyles.memoTextStyle),
              onTap: _showLoginInfo,
            ),
        ],
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    ).then((_) {
      _checkLoginStatus();
    });
  }

  void _logout() async {
    await prefs.setBool('isLoggedIn', false);
    setState(() {
      _isLoggedIn = false;
    });
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void _resetAllData() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('전체 정보 초기화', style: TextStyle(fontFamily: "Tenada")),
          content: Text('모든 데이터가 삭제됩니다. 계속하시겠습니까?', style: TextStyle(fontFamily: "Tenada")),
          actions: <Widget>[
            TextButton(
              child: Text('취소', style: TextStyle(fontFamily: "Tenada")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () async {
                await prefs.clear();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showColorPicker() {
    // 여기에 테마 색 선택 로직을 구현하세요
    // 예: 색상 선택 다이얼로그를 표시하고 선택된 색상을 저장
  }

  void _showBackgroundColorPicker() {
    // 여기에 배경색 선택 로직을 구현하세요
    // 예: 색상 선택 다이얼로그를 표시하고 선택된 색상을 저장
  }

  void _showLoginInfo() {
    if (_user == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('로그인 정보'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('회원번호: ${_user!.id}'),
              Text('닉네임: ${_user!.kakaoAccount?.profile?.nickname ?? "없음"}'),
              Text('프로필 이미지: ${_user!.kakaoAccount?.profile?.profileImageUrl ?? "없음"}'),
              Text('이메일: ${_user!.kakaoAccount?.email ?? "없음"}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}