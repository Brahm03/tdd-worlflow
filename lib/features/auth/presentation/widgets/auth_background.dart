import 'package:flutter/material.dart';
import 'package:task_app/core/consts/colors/app_colors.dart';

// * TaskListView bilan bir xil fon: grid rasm + to'q ko'k gradient
class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('assets/images/back.png')),
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.instance.lightBlue,
                AppColors.instance.darkBlue,
                AppColors.instance.darkBlue,
              ])),
      child: child,
    );
  }
}
