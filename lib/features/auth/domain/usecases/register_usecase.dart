import 'package:equatable/equatable.dart';
import 'package:task_app/core/error/failures.dart';
import 'package:task_app/core/usecases/usecase.dart';
import 'package:task_app/core/utils/either.dart';
import 'package:task_app/features/auth/domain/entities/auth_user.dart';
import 'package:task_app/features/auth/domain/repositories/auth_repository.dart';

class RegisterUsecase extends UseCase<AuthUser, RegisterParams> {
  final AuthRepository repository;

  RegisterUsecase({required this.repository});

  @override
  Future<Either<Failure, AuthUser>> call(RegisterParams params) =>
      repository.register(
        username: params.username,
        email: params.email,
        password: params.password,
      );
}

class RegisterParams extends Equatable {
  final String username;
  final String email;
  final String password;

  const RegisterParams({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [username, email, password];
}
