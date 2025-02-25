import 'package:flutter/material.dart';
import 'package:todo/theme/app_colors.dart';

class AppTheme {
  static ThemeData klkTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: AppColors.primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        iconColor: Colors.white,
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        iconColor: Colors.white,
        foregroundColor: Colors.white,
      ),
    ),
  );
}
