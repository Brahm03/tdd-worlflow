import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';
import 'package:task_app/core/consts/colors/app_colors.dart';

class AuthSubmitButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onPressed;

  const AuthSubmitButton({
    super.key,
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidGlassButton(
      width: double.infinity,
      height: 56,
      style: LiquidGlassButton.defaultStyle.copyWith(
        color: AppColors.instance.blue.withAlpha(170),
      ),
      onPressed: loading ? null : onPressed,
      child: loading
          ? CupertinoActivityIndicator(color: AppColors.instance.white)
          : Text(
              label,
              style: GoogleFonts.montserratAlternates(
                  fontSize: 17, fontWeight: FontWeight.bold),
            ),
    );
  }
}
