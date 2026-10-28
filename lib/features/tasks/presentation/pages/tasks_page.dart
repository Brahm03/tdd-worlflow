import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_app/features/auth/presentation/widgets/logout_button.dart';
import 'package:task_app/features/tasks/data/datasources/task_remote_data_source.dart';
import 'package:task_app/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:task_app/features/tasks/domain/usecases/edit_task_usecase.dart';
import 'package:task_app/features/tasks/domain/usecases/get_ads_usecase.dart';
import 'package:task_app/features/tasks/domain/usecases/get_task_usecase.dart';
import 'package:task_app/features/tasks/presentation/bloc/ads/ad_bloc.dart';
import 'package:task_app/features/tasks/presentation/bloc/ads/ad_event.dart';
import 'package:task_app/features/tasks/presentation/bloc/tasks_cubit.dart';

import '../widgets/add_task_button.dart';
import '../widgets/task_list_view.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AdBloc(GetAdsUsecase(
                taskRepository: TaskRepositoryImple(
                    dataSource: TaskRemoteDataSourceImpl())))..add(GetAdsEvent())),
        BlocProvider(
            create: (context) => TasksCubit(
                editTaskUsecase: EditTaskUsecase(
                    repository: TaskRepositoryImple(
                        dataSource: TaskRemoteDataSourceImpl())),
                usecase: GetTaskUsecase(
                    taskRepository: TaskRepositoryImple(
                        dataSource: TaskRemoteDataSourceImpl())))
              ..getTask())
      ],
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            'Tasks',
            style: GoogleFonts.montserratAlternates(
                fontSize: 30, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          actions: const [LogoutButton()],
        ),
        body: const TaskListView(),
        floatingActionButton: const AddTaskButton(),
      ),
    );
  }
}
