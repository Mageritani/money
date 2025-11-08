import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.white30, // 淺色背景
    primary: Colors.blue,
    onSurface: Colors.black, // 淺色模式下的文字顏色
  ),
  scaffoldBackgroundColor: Colors.grey.shade300,
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.black, // 深色背景
    primary: Colors.blue,
    onSurface: Colors.white, // 深色模式下的文字顏色
  ),
  scaffoldBackgroundColor: Colors.grey.shade900,
);
