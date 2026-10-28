import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/core/error/failures.dart';
import 'package:task_app/core/usecases/usecase.dart';
import 'package:task_app/core/utils/either.dart';
import 'package:task_app/features/auth/domain/entities/auth_user.dart';
import 'package:task_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:task_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:task_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_state.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

void main() {
  late MockLoginUsecase login;
  late MockRegisterUsecase register;
  late MockLogoutUsecase logout;

  const user = AuthUser(
    id: 2,
    documentId: 'd6fo8l9ixyerxj9go0o0mbyq',
    username: 'Yusufboy',
    email: 'yusufboy@gmail.com',
    jwt: 'token',
  );

  setUpAll(() {
    registerFallbackValue(const LoginParams(identifier: '', password: ''));
    registerFallbackValue(
        const RegisterParams(username: '', email: '', password: ''));
    registerFallbackValue(NoParams());
  });

  setUp(() {
    login = MockLoginUsecase();
    register = MockRegisterUsecase();
    logout = MockLogoutUsecase();
  });

  AuthBloc build() => AuthBloc(
      loginUsecase: login, registerUsecase: register, logoutUsecase: logout);

  test('boshlang\'ich holat initial', () {
    expect(build().state, const AuthState());
  });

  blocTest<AuthBloc, AuthState>(
    'login muvaffaqiyatli: [loading, success]',
    setUp: () => when(() => login.call(any()))
        .thenAnswer((_) async => Right(user)),
    build: build,
    act: (bloc) => bloc.add(const LoginSubmitted(
        identifier: 'yusufboy@gmail.com', password: '12345678')),
    expect: () => const [
      AuthState(status: AuthStatus.loading),
      AuthState(status: AuthStatus.success, user: user),
    ],
    verify: (_) => verify(() => login.call(const LoginParams(
        identifier: 'yusufboy@gmail.com', password: '12345678'))).called(1),
  );

  blocTest<AuthBloc, AuthState>(
    'login xato: [loading, failure + server xabari]',
    setUp: () => when(() => login.call(any())).thenAnswer((_) async =>
        Left(const DioFailure(message: 'Invalid identifier or password'))),
    build: build,
    act: (bloc) =>
        bloc.add(const LoginSubmitted(identifier: 'x', password: 'y')),
    expect: () => const [
      AuthState(status: AuthStatus.loading),
      AuthState(
          status: AuthStatus.failure,
          errorText: 'Invalid identifier or password'),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'register muvaffaqiyatli: [loading, success]',
    setUp: () => when(() => register.call(any()))
        .thenAnswer((_) async => Right(user)),
    build: build,
    act: (bloc) => bloc.add(const RegisterSubmitted(
        username: 'Hamidiy', email: 'hamidiy@gmail.com', password: 'Tarmoq09!')),
    expect: () => const [
      AuthState(status: AuthStatus.loading),
      AuthState(status: AuthStatus.success, user: user),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'logout: [loggedOut]',
    setUp: () => when(() => logout.call(any()))
        .thenAnswer((_) async => Right(null)),
    build: build,
    act: (bloc) => bloc.add(const LogoutRequested()),
    expect: () => const [AuthState(status: AuthStatus.loggedOut)],
  );
}
