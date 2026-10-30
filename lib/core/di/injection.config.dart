// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:task_app/core/di/register_module.dart' as _i891;
import 'package:task_app/core/storage/token_storage.dart' as _i732;
import 'package:task_app/core/utils/dio_model.dart' as _i1047;
import 'package:task_app/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i235;
import 'package:task_app/features/auth/data/repositories/auth_repository_impl.dart'
    as _i928;
import 'package:task_app/features/auth/domain/repositories/auth_repository.dart'
    as _i634;
import 'package:task_app/features/auth/domain/usecases/login_usecase.dart'
    as _i852;
import 'package:task_app/features/auth/domain/usecases/logout_usecase.dart'
    as _i709;
import 'package:task_app/features/auth/domain/usecases/register_usecase.dart'
    as _i1046;
import 'package:task_app/features/auth/presentation/bloc/auth_bloc.dart'
    as _i742;
import 'package:task_app/features/tasks/data/datasources/task_remote_data_source.dart'
    as _i888;
import 'package:task_app/features/tasks/data/repositories/task_repository_impl.dart'
    as _i305;
import 'package:task_app/features/tasks/domain/repositories/task_repository.dart'
    as _i196;
import 'package:task_app/features/tasks/domain/usecases/edit_task_usecase.dart'
    as _i309;
import 'package:task_app/features/tasks/domain/usecases/get_ads_usecase.dart'
    as _i686;
import 'package:task_app/features/tasks/domain/usecases/get_task_usecase.dart'
    as _i190;
import 'package:task_app/features/tasks/presentation/bloc/ads/ad_bloc.dart'
    as _i1066;
import 'package:task_app/features/tasks/presentation/bloc/tasks_cubit.dart'
    as _i260;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    final dioModule = _$DioModule();
    gh.lazySingleton<_i732.TokenStorage>(() => registerModule.tokenStorage);
    gh.lazySingleton<_i361.Dio>(() => dioModule.dio());
    gh.lazySingleton<_i888.TaskDataSource>(
      () => _i888.TaskRemoteDataSourceImpl(client: gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i196.TaskRepository>(
      () => _i305.TaskRepositoryImple(dataSource: gh<_i888.TaskDataSource>()),
    );
    gh.lazySingleton<_i235.AuthDataSource>(
      () => _i235.AuthRemoteDataSourceImpl(client: gh<_i361.Dio>()),
    );
    gh.factory<_i309.EditTaskUsecase>(
      () => _i309.EditTaskUsecase(repository: gh<_i196.TaskRepository>()),
    );
    gh.factory<_i686.GetAdsUsecase>(
      () => _i686.GetAdsUsecase(taskRepository: gh<_i196.TaskRepository>()),
    );
    gh.factory<_i190.GetTaskUsecase>(
      () => _i190.GetTaskUsecase(taskRepository: gh<_i196.TaskRepository>()),
    );
    gh.lazySingleton<_i634.AuthRepository>(
      () => _i928.AuthRepositoryImpl(
        dataSource: gh<_i235.AuthDataSource>(),
        storage: gh<_i732.TokenStorage>(),
      ),
    );
    gh.factory<_i260.TasksCubit>(
      () => _i260.TasksCubit(
        usecase: gh<_i190.GetTaskUsecase>(),
        editTaskUsecase: gh<_i309.EditTaskUsecase>(),
      ),
    );
    gh.factory<_i852.LoginUsecase>(
      () => _i852.LoginUsecase(repository: gh<_i634.AuthRepository>()),
    );
    gh.factory<_i709.LogoutUsecase>(
      () => _i709.LogoutUsecase(repository: gh<_i634.AuthRepository>()),
    );
    gh.factory<_i1046.RegisterUsecase>(
      () => _i1046.RegisterUsecase(repository: gh<_i634.AuthRepository>()),
    );
    gh.factory<_i742.AuthBloc>(
      () => _i742.AuthBloc(
        loginUsecase: gh<_i852.LoginUsecase>(),
        registerUsecase: gh<_i1046.RegisterUsecase>(),
        logoutUsecase: gh<_i709.LogoutUsecase>(),
      ),
    );
    gh.factory<_i1066.AdBloc>(() => _i1066.AdBloc(gh<_i686.GetAdsUsecase>()));
    return this;
  }
}

class _$RegisterModule extends _i891.RegisterModule {}

class _$DioModule extends _i1047.DioModule {}
