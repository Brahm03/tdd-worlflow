import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:task_app/core/consts/themes/app_themes.dart';
import 'package:task_app/core/router/app_router.dart';

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: AppThemes.instance.light,
      dark: AppThemes.instance.dark,
      initial: AdaptiveThemeMode.dark,
      builder: (light, dark) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: light,
        darkTheme: dark,
        themeMode: ThemeMode.dark,
        routerConfig: appRouter,
      ),
    );
  }
}
