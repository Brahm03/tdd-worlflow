import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_app/core/consts/colors/app_colors.dart';

// * server xatosi — panel ostida, qizil priority chizig'i bilan
class AuthErrorText extends StatelessWidget {
  final String? message;

  const AuthErrorText({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      alignment: Alignment.topLeft,
      child: message == null
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: const EdgeInsets.only(top: 16, left: 4),
              child: Row(
                spacing: 12,
                children: [
                  Container(
                    height: 5,
                    width: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.5),
                      color: AppColors.instance.red,
                    ),
                  ),
                  Expanded(
                    child: Semantics(
                      liveRegion: true,
                      child: Text(
                        message!,
                        style: GoogleFonts.montserratAlternates(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
