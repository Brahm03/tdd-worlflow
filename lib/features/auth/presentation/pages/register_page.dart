import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app/core/router/app_router.dart';
import 'package:task_app/core/di/injection.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_state.dart';

import '../widgets/auth_error_text.dart';
import '../widgets/auth_field_group.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_page_body.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/auth_switch_link.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/priority_bars.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: const Scaffold(body: _RegisterForm()),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void submit() {
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(RegisterSubmitted(
          username: usernameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          context.go(AppRoutes.instance.home);
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: AutofillGroup(
            child: AuthPageBody(children: [
              const AuthHeader(
                title: 'Create account',
                subtitle: 'Keep track of what you commit to.',
              ),
              const SizedBox(height: 40),
              AuthFieldGroup(children: [
                AuthTextField(
                  controller: usernameController,
                  label: 'Username',
                  autofillHints: const [AutofillHints.newUsername],
                  validator: (v) => (v == null || v.trim().length < 3)
                      ? 'Use at least 3 characters'
                      : null,
                ),
                AuthTextField(
                  controller: emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  validator: (v) {
                    final email = v?.trim() ?? '';
                    final valid =
                        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
                    return valid ? null : 'Enter a valid email address';
                  },
                ),
                AuthTextField(
                  controller: passwordController,
                  label: 'Password',
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.newPassword],
                  validator: (v) => (v == null || v.length < 6)
                      ? 'Use at least 6 characters'
                      : null,
                  // * parol kuchi indikatorini yangilash uchun
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => submit(),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 4),
                child:
                    PasswordStrengthBars(password: passwordController.text),
              ),
              AuthErrorText(
                message: state.status == AuthStatus.failure
                    ? state.errorText
                    : null,
              ),
              const SizedBox(height: 28),
              AuthSubmitButton(
                label: 'Create account',
                loading: state.status == AuthStatus.loading,
                onPressed: submit,
              ),
              const SizedBox(height: 12),
              AuthSwitchLink(
                question: 'Already have an account?',
                action: 'Log in',
                onTap: () => context.go(AppRoutes.instance.login),
              ),
            ]),
          ),
        );
      },
    );
  }
}
