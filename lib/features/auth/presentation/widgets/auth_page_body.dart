import 'package:flutter/material.dart';

import 'auth_background.dart';

// * scroll + chap tomonga tekislangan, keng ekranda 440px dan oshmaydi
class AuthPageBody extends StatelessWidget {
  final List<Widget> children;

  const AuthPageBody({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
