import 'package:flutter/material.dart';
import 'package:task_app/core/consts/colors/app_colors.dart';

class AppThemes {
  static AppThemes instance = AppThemes._();
  AppThemes._();

  final light = ThemeData(
      scaffoldBackgroundColor: AppColors.instance.blue,
      colorScheme: ColorScheme.light(primary: AppColors.instance.black));
  final dark = ThemeData(
      colorScheme: ColorScheme.dark(primary: AppColors.instance.black));
}
