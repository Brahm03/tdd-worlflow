import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/core/error/failures.dart';
import 'package:task_app/core/usecases/usecase.dart';
import 'package:task_app/core/utils/either.dart';
import 'package:task_app/features/auth/domain/entities/auth_user.dart';
import 'package:task_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:task_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:task_app/features/auth/domain/usecases/register_usecase.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final LogoutUsecase logoutUsecase;

  AuthBloc({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.logoutUsecase,
  }) : super(const AuthState()) {
    on<LoginSubmitted>(_onLogin);
    on<RegisterSubmitted>(_onRegister);
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onLogin(LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await loginUsecase.call(LoginParams(
      identifier: event.identifier,
      password: event.password,
    ));
    _emitResult(result, emit);
  }

  Future<void> _onRegister(
      RegisterSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await registerUsecase.call(RegisterParams(
      username: event.username,
      email: event.email,
      password: event.password,
    ));
    _emitResult(result, emit);
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    await logoutUsecase.call(NoParams());
    emit(const AuthState(status: AuthStatus.loggedOut));
  }

  void _emitResult(Either<Failure, AuthUser> result, Emitter<AuthState> emit) {
    if (result.isRight) {
      emit(state.copyWith(status: AuthStatus.success, user: result.right));
    } else {
      emit(state.copyWith(
          status: AuthStatus.failure,
          errorText: result.left.message ?? 'Something went wrong'));
    }
  }
}
