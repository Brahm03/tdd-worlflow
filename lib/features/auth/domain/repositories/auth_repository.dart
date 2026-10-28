import 'package:task_app/core/error/failures.dart';
import 'package:task_app/core/utils/either.dart';
import 'package:task_app/features/auth/domain/entities/auth_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUser>> login({
    required String identifier,
    required String password,
  });
  Future<Either<Failure, AuthUser>> register({
    required String username,
    required String email,
    required String password,
  });
  Future<void> logout();
}
