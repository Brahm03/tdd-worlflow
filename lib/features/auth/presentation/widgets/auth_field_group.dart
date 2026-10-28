import 'package:flutter/material.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';
import 'package:task_app/core/consts/colors/app_colors.dart';

// * maydonlar bitta glass panelda, orasida ingichka chiziq
class AuthFieldGroup extends StatelessWidget {
  final List<Widget> children;

  const AuthFieldGroup({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        items.add(Divider(
          height: 1,
          indent: 20,
          color: AppColors.instance.white.withAlpha(25),
        ));
      }
      items.add(children[i]);
    }
    return LiquidGlassLite(
      shape: const LiquidGlassShape(cornerRadius: 24),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(mainAxisSize: MainAxisSize.min, children: items),
      ),
    );
  }
}
