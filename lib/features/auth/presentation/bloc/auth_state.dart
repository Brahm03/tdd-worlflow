import 'package:equatable/equatable.dart';
import 'package:task_app/features/auth/domain/entities/auth_user.dart';

enum AuthStatus { initial, loading, success, failure, loggedOut }

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthUser? user;
  final String? errorText;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorText,
  });

  // * errorText har safar qayta yoziladi, eski xato qolib ketmasin
  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    String? errorText,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorText: errorText,
    );
  }

  @override
  List<Object?> get props => [status, user, errorText];
}
