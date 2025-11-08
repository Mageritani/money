import 'package:flutter/material.dart';
import 'package:money/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode; // ✅ 加入這個

  void setThemeData(ThemeData themeData) {
    // 改名
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    // 修正拼字
    if (_themeData == lightMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
    notifyListeners(); // ✅ 加入這行!很重要!
  }
}
