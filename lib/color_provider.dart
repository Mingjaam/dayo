import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'styles.dart';

class ColorProvider with ChangeNotifier {
  Color _memoBubbleColor = AppStyles.lightPink;
  Color _commonBackgroundColor = Colors.white; 

  Color get memoBubbleColor => _memoBubbleColor;
  Color get commonBackgroundColor => _commonBackgroundColor;
  ColorProvider() {
    _loadMemoColor(); // 색상 로드
    _loadBGColor();
  }

  void changeMemoColor(Color newColor) {
    _memoBubbleColor = newColor;
    _saveMemoColor(newColor); // 색상 저장
    notifyListeners(); // 색상이 변경되면 UI를 업데이트
  }

  Future<void> _saveMemoColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('memoBubbleColor', color.value); // 색상 값을 저장
  }

  Future<void> _loadMemoColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt('memoBubbleColor');
    if (colorValue != null) {
      _memoBubbleColor = Color(colorValue); // 저장된 색상 값을 불러옴
    }
  }

  void changeBGColor(Color newColor) {
    _commonBackgroundColor = newColor;
    _saveBGColor(newColor);
    notifyListeners(); // UI 업데이트를 위해 반드시 호출
  }

  Future<void> _loadBGColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt('commonBackgroundColor');
    if (colorValue != null) {
      _commonBackgroundColor = Color(colorValue);
    }
  }

  Future<void> _saveBGColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('commonBackgroundColor', color.value);
  }


}



