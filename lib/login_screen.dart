import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart' 제거
import 'styles.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    // Kakao SDK 초기화
    KakaoSdk.init(nativeAppKey: '1aaa8e178cff50abce904c8811b4abf7');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'DayO',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppStyles.textColor,
                  fontFamily: AppStyles.fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48),
              ElevatedButton(
                child: Text('카카오톡으로 로그인', style: TextStyle(fontFamily: "Tenada")),
                onPressed: _loginWithKakao,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFEE500),
                  foregroundColor: Colors.black87,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              // 애플 로그인 버튼 제거
            ],
          ),
        ),
      ),
    );
  }

  void _loginWithKakao() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      OAuthToken token;
      if (isInstalled) {
        try {
          token = await UserApi.instance.loginWithKakaoTalk();
          print('카카오톡으로 로그인 성공');
        } catch (error) {
          print('카카오톡으로 로그인 실패 $error');
          // 카카오톡에서 로그인 취소한 경우 카카오계정으로 로그인 시도
          try {
            token = await UserApi.instance.loginWithKakaoAccount();
            print('카카오계정으로 로그인 성공');
          } catch (error) {
            print('카카오계정으로 로그인 실패 $error');
            _showErrorDialog('카카오 로그인 실패', '로그인 과정에서 오류가 발생했습니다.');
            return;
          }
        }
      } else {
        try {
          token = await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
          _showErrorDialog('카카오 로그인 실패', '로그인 과정에서 오류가 발생했습니다.');
          return;
        }
      }

      print('카카오 로그인 성공 ${token.accessToken}');
      
      // 로그인 성공 후 처리
      await prefs.setBool('isLoggedIn', true);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } catch (error) {
      print('카카오 로그인 실패 $error');
      _showErrorDialog('카카오 로그인 실패', '로그인 과정에서 오류가 발생했습니다.');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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