import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends AuthEvent {
  final String identifier;
  final String password;

  const LoginSubmitted({required this.identifier, required this.password});

  @override
  List<Object?> get props => [identifier, password];
}

class RegisterSubmitted extends AuthEvent {
  final String username;
  final String email;
  final String password;

  const RegisterSubmitted({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [username, email, password];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
