import 'package:task_app/features/auth/domain/entities/auth_user.dart';

// * /api/auth/local va /api/auth/local/register javobi:
// * { jwt, refreshToken?, user: { id, documentId, username, email } }
class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.documentId,
    required super.username,
    required super.email,
    required super.jwt,
    super.refreshToken,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    return AuthUserModel(
      id: user['id'] as int,
      documentId: user['documentId'] as String? ?? '',
      username: user['username'] as String? ?? '',
      email: user['email'] as String? ?? '',
      jwt: json['jwt'] as String,
      refreshToken: json['refreshToken'] as String?,
    );
  }
}
