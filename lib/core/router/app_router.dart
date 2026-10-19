import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app/features/tasks/presentation/pages/tasks_page.dart';

class AppRoutes {
  static AppRoutes instance = AppRoutes._();
  AppRoutes._();

  final String home = '/home';
}

GoRouter appRouter =
    GoRouter(initialLocation: AppRoutes.instance.home, routes: [
  GoRoute(
    path: AppRoutes.instance.home,
    pageBuilder: (context, state) => MaterialPage(child: TasksPage()),
  )
]);
