import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app/core/storage/token_storage.dart';
import 'package:task_app/features/auth/presentation/pages/login_page.dart';
import 'package:task_app/features/auth/presentation/pages/register_page.dart';
import 'package:task_app/features/tasks/presentation/pages/tasks_page.dart';

class AppRoutes {
  static AppRoutes instance = AppRoutes._();
  AppRoutes._();

  final String home = '/home';
  final String login = '/login';
  final String register = '/register';
}

GoRouter appRouter = GoRouter(
    initialLocation: AppRoutes.instance.home,
    // * token yo'q bo'lsa login'ga, bor bo'lsa auth sahifalaridan home'ga
    redirect: (context, state) {
      final loggedIn = TokenStorage.instance.isLoggedIn;
      final onAuthPage = state.matchedLocation == AppRoutes.instance.login ||
          state.matchedLocation == AppRoutes.instance.register;
      if (!loggedIn && !onAuthPage) return AppRoutes.instance.login;
      if (loggedIn && onAuthPage) return AppRoutes.instance.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.instance.home,
        pageBuilder: (context, state) => MaterialPage(child: TasksPage()),
      ),
      GoRoute(
        path: AppRoutes.instance.login,
        pageBuilder: (context, state) => MaterialPage(child: LoginPage()),
      ),
      GoRoute(
        path: AppRoutes.instance.register,
        pageBuilder: (context, state) => MaterialPage(child: RegisterPage()),
      ),
    ]);
