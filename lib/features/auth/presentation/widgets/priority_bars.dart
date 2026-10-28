import 'package:flutter/material.dart';
import 'package:task_app/core/consts/colors/app_colors.dart';

// * task tile'dagi priority chizig'i (20x5) — bu yerda 3 tasi qatorda
// * colors[i] == null bo'lsa chiziq o'chiq holatda chiziladi
class PriorityBars extends StatelessWidget {
  final List<Color?> colors;
  final bool animateIn;

  const PriorityBars({super.key, required this.colors, this.animateIn = false});

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: List.generate(colors.length, (index) {
        final bar = AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 5,
          width: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.5),
            color: colors[index] ?? AppColors.instance.white.withAlpha(30),
          ),
        );
        if (!animateIn || reduceMotion) return bar;

        // * sahifa ochilganda chiziqlar birin-ketin o'sib chiqadi
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 450 + index * 150),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) => Align(
            alignment: Alignment.centerLeft,
            widthFactor: value,
            child: child,
          ),
          child: bar,
        );
      }),
    );
  }
}

// * parol kuchi: 1 -> qizil, 2 -> sariq, 3 -> yashil
class PasswordStrengthBars extends StatelessWidget {
  final String password;

  const PasswordStrengthBars({super.key, required this.password});

  static int score(String password) {
    if (password.isEmpty) return 0;
    var score = 1;
    final hasLetter = password.contains(RegExp(r'[A-Za-z]'));
    final hasDigit = password.contains(RegExp(r'\d'));
    final hasExtra = password.contains(RegExp(r'[^A-Za-z0-9]')) ||
        (password.contains(RegExp(r'[A-Z]')) &&
            password.contains(RegExp(r'[a-z]')));
    if (password.length >= 8 && hasLetter && hasDigit) score++;
    if (score == 2 && hasExtra) score++;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final s = score(password);
    final color = switch (s) {
      1 => AppColors.instance.red,
      2 => AppColors.instance.yellow,
      _ => AppColors.instance.green,
    };
    final label = switch (s) {
      0 => 'Use 8+ characters with a number',
      1 => 'Weak',
      2 => 'Okay',
      _ => 'Strong',
    };
    return Row(
      spacing: 12,
      children: [
        PriorityBars(colors: List.generate(3, (i) => i < s ? color : null)),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppColors.instance.grey),
        ),
      ],
    );
  }
}
