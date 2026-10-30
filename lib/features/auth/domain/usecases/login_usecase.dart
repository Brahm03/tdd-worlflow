import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:task_app/core/error/failures.dart';
import 'package:task_app/core/usecases/usecase.dart';
import 'package:task_app/core/utils/either.dart';
import 'package:task_app/features/auth/domain/entities/auth_user.dart';
import 'package:task_app/features/auth/domain/repositories/auth_repository.dart';

@injectable
class LoginUsecase extends UseCase<AuthUser, LoginParams> {
  final AuthRepository repository;

  LoginUsecase({required this.repository});

  @override
  Future<Either<Failure, AuthUser>> call(LoginParams params) =>
      repository.login(
          identifier: params.identifier, password: params.password);
}

// * identifier -> email yoki username
class LoginParams extends Equatable {
  final String identifier;
  final String password;

  const LoginParams({required this.identifier, required this.password});

  @override
  List<Object?> get props => [identifier, password];
}
