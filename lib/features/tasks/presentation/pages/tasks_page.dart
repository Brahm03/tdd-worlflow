import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_app/core/di/injection.dart';
import 'package:task_app/features/auth/presentation/widgets/logout_button.dart';
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
            create: (context) => getIt<AdBloc>()),
        BlocProvider(
            create: (context) => getIt<TasksCubit>()..getTask())
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
