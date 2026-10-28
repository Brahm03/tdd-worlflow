import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final int id;
  final String documentId;
  final String username;
  final String email;
  final String jwt;
  final String? refreshToken;

  const AuthUser({
    required this.id,
    required this.documentId,
    required this.username,
    required this.email,
    required this.jwt,
    this.refreshToken,
  });

  @override
  List<Object?> get props =>
      [id, documentId, username, email, jwt, refreshToken];
}
