import 'package:flutter/material.dart';

class AppStyles {
  // 기본 색상
  static const Color _lightGrey = Color(0xFFCACDD3);  // 연한 회색
  static const Color _lightPink = Color(0xFFF5EBEB);  // 연한 분홍색
  static const Color _lightPeach = Color(0xFFEECEC9);  // 연한 살구색
  static const Color _mediumPink = Color(0xFFC49894);  // 중간 톤의 분홍색
  static const Color _mediumBlueGrey = Color(0xFF92A5BF);  // 중간 톤의 청회색
  static const Color _beige = Color(0xFFF6F5F2);  // 연한 베이지색

  // 앱 색상 (쉽게 변경 가능)
  static const Color primaryColor = _beige;
  static const Color accentColor = _mediumBlueGrey;  // 강조색
  static const Color textColor = Colors.black;  // 주 텍스트 색상
  static const Color secondaryTextColor = Colors.grey;  // 보조 텍스트 색상
  static const Color borderColor = Colors.black;  // 테두리 색상
  static const Color inputBackgroundColor = _lightPink;  // 입력 필드 배경색
  static const Color appBarBackgroundColor = _beige;  // 앱바 배경색
  static const Color memoBubbleColor = _lightPink;  // 메모 박스 배경색

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: primaryColor,
    appBarTheme: AppBarTheme(
      color: appBarBackgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Tenada'),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: textColor, fontFamily: 'Tenada'),
      bodyMedium: TextStyle(color: textColor, fontFamily: 'Tenada'),
      titleLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontFamily: 'Tenada'),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: inputBackgroundColor,
      filled: true,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(25.0),
      ),
      hintStyle: TextStyle(color: secondaryTextColor),
    ),
    dividerColor: borderColor,
    colorScheme: ColorScheme.light(
      primary: accentColor,
      secondary: secondaryTextColor,
    ),
  );

  static const TextStyle headerStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle subHeaderStyle = TextStyle(
    fontSize: 14,
    color: secondaryTextColor,
  );

  static const TextStyle memoTextStyle = TextStyle(
    fontSize: 16,
    color: textColor,
  );

  static const TextStyle memoTimeStyle = TextStyle(
    fontSize: 12,
    color: secondaryTextColor,
  );

  static BoxDecoration memoBubbleDecoration = BoxDecoration(
    color: memoBubbleColor,
    borderRadius: BorderRadius.circular(12.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  );
}