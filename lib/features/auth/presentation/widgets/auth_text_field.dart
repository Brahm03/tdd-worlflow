import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_app/core/consts/colors/app_colors.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.autofillHints,
    this.validator,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool obscure = widget.isPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: obscure,
      autocorrect: !widget.isPassword,
      enableSuggestions: !widget.isPassword,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      cursorColor: AppColors.instance.white,
      style: GoogleFonts.montserratAlternates(
          fontSize: 16, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: GoogleFonts.montserratAlternates(
            fontSize: 14, color: AppColors.instance.grey),
        floatingLabelStyle: GoogleFonts.montserratAlternates(
            fontSize: 13, color: AppColors.instance.grey),
        errorStyle: GoogleFonts.montserratAlternates(
            fontSize: 12, color: AppColors.instance.red),
        border: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        suffixIcon: widget.isPassword
            ? IconButton(
                tooltip: obscure ? 'Show password' : 'Hide password',
                onPressed: () => setState(() => obscure = !obscure),
                icon: Icon(
                  obscure ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                  size: 20,
                  color: AppColors.instance.grey,
                ),
              )
            : null,
      ),
    );
  }
}
