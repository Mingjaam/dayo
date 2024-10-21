import 'package:flutter/material.dart';
import 'styles.dart';

class ColorProvider with ChangeNotifier {
  Color _memoBubbleColor = AppStyles.lightPink; // 기본 메모 색상

  Color get memoBubbleColor => _memoBubbleColor;

  void changeColor(Color newColor) {
    _memoBubbleColor = newColor;
    notifyListeners();
  }
}