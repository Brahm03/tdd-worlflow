import 'package:injectable/injectable.dart';
import 'package:task_app/core/error/failures.dart';
import 'package:task_app/core/storage/token_storage.dart';
import 'package:task_app/core/utils/either.dart';
import 'package:task_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:task_app/features/auth/data/models/auth_user_model.dart';
import 'package:task_app/features/auth/domain/entities/auth_user.dart';
import 'package:task_app/features/auth/domain/repositories/auth_repository.dart';



@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource dataSource;
  final TokenStorage storage;

  AuthRepositoryImpl({required this.dataSource, required this.storage});

  @override
  Future<Either<Failure, AuthUser>> login({
    required String identifier,
    required String password,
  }) async {
    final result =
        await dataSource.login(identifier: identifier, password: password);
    return _saveToken(result);
  }

  @override
  Future<Either<Failure, AuthUser>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final result = await dataSource.register(
        username: username, email: email, password: password);
    return _saveToken(result);
  }

  @override
  Future<void> logout() => storage.clear();

  // * muvaffaqiyatli bo'lsa tokenni saqlab qo'yamiz
  Future<Either<Failure, AuthUser>> _saveToken(
      Either<Failure, AuthUserModel> result) async {
    if (result.isRight) {
      final user = result.right;
      await storage.save(accessToken: user.jwt, refreshToken: user.refreshToken);
      return Right(user);
    } else {
      return Left(result.left);
    }
  }
}
