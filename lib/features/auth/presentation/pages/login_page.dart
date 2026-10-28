import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app/core/router/app_router.dart';
import 'package:task_app/features/auth/auth_injection.dart';
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

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => createAuthBloc(),
      child: const Scaffold(body: _LoginForm()),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final formKey = GlobalKey<FormState>();
  final identifierController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    identifierController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void submit() {
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(LoginSubmitted(
          identifier: identifierController.text.trim(),
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
                title: 'Welcome back',
                subtitle: 'Log in to see your tasks.',
              ),
              const SizedBox(height: 40),
              AuthFieldGroup(children: [
                AuthTextField(
                  controller: identifierController,
                  label: 'Email or username',
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [
                    AutofillHints.email,
                    AutofillHints.username
                  ],
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Enter your email or username'
                      : null,
                ),
                AuthTextField(
                  controller: passwordController,
                  label: 'Password',
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Enter your password' : null,
                  onSubmitted: (_) => submit(),
                ),
              ]),
              AuthErrorText(
                message: state.status == AuthStatus.failure
                    ? state.errorText
                    : null,
              ),
              const SizedBox(height: 28),
              AuthSubmitButton(
                label: 'Log in',
                loading: state.status == AuthStatus.loading,
                onPressed: submit,
              ),
              const SizedBox(height: 12),
              AuthSwitchLink(
                question: 'No account yet?',
                action: 'Create one',
                onTap: () => context.go(AppRoutes.instance.register),
              ),
            ]),
          ),
        );
      },
    );
  }
}
