import 'package:task_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:task_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:task_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:task_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:task_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_bloc.dart';

AuthBloc createAuthBloc() {
  final repository = AuthRepositoryImpl(dataSource: AuthRemoteDataSourceImpl());
  return AuthBloc(
    loginUsecase: LoginUsecase(repository: repository),
    registerUsecase: RegisterUsecase(repository: repository),
    logoutUsecase: LogoutUsecase(repository: repository),
  );
}
