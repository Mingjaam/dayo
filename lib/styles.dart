import 'package:flutter/material.dart';

class AppStyles {
  // 기본 색상
  static const Color lightGrey = Color(0xFFCACDD3);  // 연한 회색
  static const Color lightPink = Color(0xFFF5EBEB);  // 연한 분홍색
  static const Color lightPeach = Color(0xFFEECEC9);  // 연한 살구색
  static const Color mediumPink = Color(0xFFC49894);  // 중간 톤의 분홍색
  static const Color mediumBlueGrey = Color(0xFF92A5BF);  // 중간 톤의 청회색
  static const Color beige = Color(0xFFF6F5F2);  // 연한 베이지색

  // 앱 색상 (쉽게 변경 가능)
  static const Color primaryColor = beige;
  static const Color accentColor = mediumBlueGrey;  // 강조색
  static const Color textColor = Colors.black;  // 주 텍스트 색상
  static const Color secondaryTextColor = Colors.grey;  // 보조 텍스트 색상
  static const Color borderColor = Colors.black;  // 테두리 색상
  static const Color inputBackgroundColor = lightPink;  // 입력 필드 배경색
  static const Color appBarBackgroundColor = beige;  // 앱바 배경색
  static const Color memoBubbleColor = lightPink;  // 메모 박스 배경색

  static const String fontFamily = 'Tenada';

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: primaryColor,
    appBarTheme: AppBarTheme(
      color: appBarBackgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: fontFamily),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: textColor, fontFamily: fontFamily),
      bodyMedium: TextStyle(color: textColor, fontFamily: fontFamily),
      titleLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontFamily: fontFamily),
    ).apply(
      bodyColor: textColor,
      displayColor: textColor,
      fontFamily: fontFamily,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: inputBackgroundColor,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: secondaryTextColor, fontFamily: fontFamily),
    ),
    dividerColor: borderColor,
    colorScheme: ColorScheme.light(
      primary: accentColor,
      secondary: secondaryTextColor,
    ),
  );

  static const TextStyle headerStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textColor,
    fontFamily: fontFamily,
  );

  static const TextStyle subHeaderStyle = TextStyle(
    fontSize: 14,
    color: secondaryTextColor,
  );

  static const TextStyle memoTextStyle = TextStyle(
    fontSize: 16,
    color: textColor,
    fontFamily: fontFamily,
  );

  static const TextStyle memoTimeStyle = TextStyle(
    fontSize: 12,
    color: secondaryTextColor,
    fontFamily: fontFamily,
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

  // 캘린더 관련 색상
  static const Color calendarCellBackground = Color(0xFFFFFAFA);  // 기본 셀 배경색
  static const Color calendarTodayBackground = lightPink;  // 오늘 날짜 배경색
  static const Color calendarSelectedBackground = lightPink;  // 선택된 날짜 배경색
  static const Color calendarWeekendText = Color(0xFFFF69B4);  // 주말 텍스트 색상
  static const Color calendarDefaultText = Colors.black87;  // 기본 텍스트 색상
  static const Color calendarOutsideText = Colors.grey;  // 현재 월 외의 날짜 텍스트 색상

  // 캘린더 스타일
  static const calendarDaysOfWeekStyle = TextStyle(
    color: calendarDefaultText,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  static const calendarHeaderStyle = TextStyle(
    color: calendarDefaultText,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static BoxDecoration calendarCellDecoration({
    required bool isToday,
    required bool isSelected,
    required bool isWeekend,
  }) {
    return BoxDecoration(
      color: isSelected
          ? calendarSelectedBackground
          : (isToday ? calendarTodayBackground : calendarCellBackground),
      border: Border.all(color: Colors.grey[300]!),
      borderRadius: BorderRadius.circular(4),
    );
  }

  static TextStyle calendarDayTextStyle({
    required bool isToday,
    required bool isSelected,
    required bool isWeekend,
    required bool isOutside,
  }) {
    return TextStyle(
      color: isOutside
          ? calendarOutsideText
          : (isWeekend ? calendarWeekendText : calendarDefaultText),
      fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.normal,
      fontSize: 14,
      fontFamily: fontFamily,
    );
  }

  // 기존 스타일 정의...
}