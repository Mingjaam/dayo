import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'memo_screen.dart';
import 'styles.dart';
import 'loading_screen.dart';
import 'login_screen.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DayO',
      theme: AppStyles.lightTheme,
      home: FutureBuilder(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          } else {
            if (snapshot.data == true) {
              return MainScreen();
            } else {
              return LoginScreen();
            }
          }
        },
      ),
    );
  }

  Future<bool> _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 2)); // 로딩 화면을 보여주기 위한 지연
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return isLoggedIn;
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MemoScreen(),
    );
  }
}
