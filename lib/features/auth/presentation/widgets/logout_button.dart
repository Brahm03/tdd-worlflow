import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app/core/router/app_router.dart';
import 'package:task_app/features/auth/auth_injection.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_state.dart';

// * TasksPage app bar'idagi chiqish tugmasi
class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => createAuthBloc(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.loggedOut) {
            context.go(AppRoutes.instance.login);
          }
        },
        child: Builder(
          builder: (context) => IconButton(
            tooltip: 'Log out',
            icon: const Icon(CupertinoIcons.square_arrow_right),
            onPressed: () =>
                context.read<AuthBloc>().add(const LogoutRequested()),
          ),
        ),
      ),
    );
  }
}
