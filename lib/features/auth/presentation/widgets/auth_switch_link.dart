import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_app/core/consts/colors/app_colors.dart';

// * "Akkaunt yo'qmi? Yaratish" kabi pastki havola
class AuthSwitchLink extends StatelessWidget {
  final String question;
  final String action;
  final VoidCallback onTap;

  const AuthSwitchLink({
    super.key,
    required this.question,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          question,
          style: GoogleFonts.montserratAlternates(
              fontSize: 14, color: AppColors.instance.grey),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
              foregroundColor: AppColors.instance.white),
          child: Text(
            action,
            style: GoogleFonts.montserratAlternates(
                fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
