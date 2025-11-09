import 'package:flutter/material.dart';

// 淺色模式 - 以白灰為主,黃色作為強調色
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    // 主色 - 金黃色
    primary: Color(0xFFFFC107), // 亮黃色
    onPrimary: Color(0xFF000000), // 黃色上的文字 - 黑色
    primaryContainer: Color(0xFFFFE082), // 淺黃色容器
    // 次要色 - 深灰色
    secondary: Color(0xFF424242), // 深灰
    onSecondary: Color(0xFFFFFFFF), // 深灰上的文字 - 白色
    secondaryContainer: Color(0xFF757575), // 中灰色容器
    // 背景色
    surface: Color(0xFFFFFFFF), // 純白背景
    onSurface: Color(0xFF212121), // 背景上的文字 - 深黑
    // 卡片/容器背景
    surfaceContainerHighest: Color(0xFFF5F5F5), // 淺灰色
    // 錯誤色
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
  ),

  // Scaffold 背景
  scaffoldBackgroundColor: Color(0xFFFAFAFA), // 極淺灰
  // 卡片顏色
  cardColor: Color(0xFFFFFFFF), // 白色卡片
  // AppBar
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFFFFFFF), // 白色
    foregroundColor: Color(0xFF212121), // 深黑文字
    elevation: 0,
    iconTheme: IconThemeData(color: Color(0xFF424242)),
  ),

  // 文字主題
  textTheme: TextTheme(
    displayLarge: TextStyle(
      color: Color(0xFF212121),
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      color: Color(0xFF212121),
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(color: Color(0xFF424242)),
    bodyMedium: TextStyle(color: Color(0xFF616161)),
  ),

  // 底部導航欄 - 淺色模式
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 35, 35, 35), // 白色背景
    selectedItemColor: Color.fromARGB(255, 255, 255, 255), // 選中時黃色
    unselectedItemColor: Color(0xFF9E9E9E), // 未選中灰色
    elevation: 8,
    type: BottomNavigationBarType.fixed,
  ),

  // 圖示主題
  iconTheme: IconThemeData(color: Color(0xFF424242)),

  // 分隔線顏色
  dividerColor: Color(0xFFE0E0E0),
);

// 深色模式 - 以黑灰為主,黃色作為強調色
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    // 主色 - 金黃色
    primary: Color(0xFFFFD54F), // 柔和的黃色
    onPrimary: Color(0xFF000000), // 黃色上的文字 - 黑色
    primaryContainer: Color(0xFFFFA000), // 深黃色容器
    // 次要色 - 淺灰色
    secondary: Color(0xFFBDBDBD), // 淺灰
    onSecondary: Color(0xFF000000), // 淺灰上的文字 - 黑色
    secondaryContainer: Color(0xFF757575), // 中灰色容器
    // 背景色
    surface: Color(0xFF1E1E1E), // 深黑背景
    onSurface: Color(0xFFE0E0E0), // 背景上的文字 - 淺灰白
    // 卡片/容器背景
    surfaceContainerHighest: Color(0xFF2C2C2C), // 中度黑灰
    // 錯誤色
    error: Color(0xFFEF5350),
    onError: Color(0xFF000000),
  ),

  // Scaffold 背景
  scaffoldBackgroundColor: Color(0xFF121212), // 純黑
  // 卡片顏色
  cardColor: Color(0xFF1E1E1E), // 深灰卡片
  // AppBar
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E), // 深灰
    foregroundColor: Color(0xFFE0E0E0), // 淺灰白文字
    elevation: 0,
    iconTheme: IconThemeData(color: Color(0xFFBDBDBD)),
  ),

  // 文字主題
  textTheme: TextTheme(
    displayLarge: TextStyle(
      color: Color(0xFFFFFFFF),
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      color: Color(0xFFE0E0E0),
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(color: Color(0xFFBDBDBD)),
    bodyMedium: TextStyle(color: Color(0xFF9E9E9E)),
  ),

  // 底部導航欄 - 深色模式
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 215, 215, 215), // 深灰背景
    selectedItemColor: Color.fromARGB(255, 0, 0, 0), // 選中時黃色
    unselectedItemColor: Color(0xFF757575), // 未選中深灰
    elevation: 8,
    type: BottomNavigationBarType.fixed,
  ),

  // 圖示主題
  iconTheme: IconThemeData(color: Color(0xFFBDBDBD)),

  // 分隔線顏色
  dividerColor: Color(0xFF424242),
);
