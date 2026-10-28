import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_app/core/consts/colors/app_colors.dart';

import 'priority_bars.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PriorityBars(
          animateIn: true,
          colors: [
            AppColors.instance.green,
            AppColors.instance.yellow,
            AppColors.instance.red,
          ],
        ),
        const SizedBox(height: 28),
        Text(
          title,
          style: GoogleFonts.montserratAlternates(
              fontSize: 36, fontWeight: FontWeight.bold, height: 1.1),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: GoogleFonts.montserratAlternates(
              fontSize: 15, color: AppColors.instance.grey),
        ),
      ],
    );
  }
}
