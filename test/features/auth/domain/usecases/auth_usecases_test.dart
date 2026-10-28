import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/core/error/failures.dart';
import 'package:task_app/core/utils/either.dart';
import 'package:task_app/features/auth/domain/entities/auth_user.dart';
import 'package:task_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:task_app/features/auth/domain/usecases/register_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;

  const user = AuthUser(
    id: 2,
    documentId: 'd6fo8l9ixyerxj9go0o0mbyq',
    username: 'Yusufboy',
    email: 'yusufboy@gmail.com',
    jwt: 'token',
  );

  setUp(() => repository = MockAuthRepository());

  test('LoginUsecase repository.login ga identifier va parolni uzatadi',
      () async {
    when(() => repository.login(
            identifier: any(named: 'identifier'),
            password: any(named: 'password')))
        .thenAnswer((_) async => Right(user));

    final result = await LoginUsecase(repository: repository).call(
        const LoginParams(identifier: 'yusufboy@gmail.com', password: '123'));

    expect(result.right, user);
    verify(() => repository.login(
        identifier: 'yusufboy@gmail.com', password: '123')).called(1);
  });

  test('RegisterUsecase xatoni qaytaradi', () async {
    when(() => repository.register(
            username: any(named: 'username'),
            email: any(named: 'email'),
            password: any(named: 'password')))
        .thenAnswer((_) async =>
            Left(const DioFailure(message: 'Email or Username are already taken')));

    final result = await RegisterUsecase(repository: repository).call(
        const RegisterParams(
            username: 'Hamidiy', email: 'h@gmail.com', password: 'Tarmoq09!'));

    expect(result.isLeft, true);
    expect(result.left.message, 'Email or Username are already taken');
  });
}
