import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/core/consts/colors/app_colors.dart';
import 'package:task_app/core/usecases/usecase.dart';
import 'package:task_app/features/tasks/domain/usecases/edit_task_usecase.dart';
import 'package:task_app/features/tasks/domain/usecases/get_task_usecase.dart';
import 'package:task_app/features/tasks/presentation/bloc/tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final GetTaskUsecase usecase;
  final EditTaskUsecase editTaskUsecase;

  TasksCubit({required this.usecase, required this.editTaskUsecase})
      : super(TasksState(status: TaskStatus.loading));

  Future<void> getTask() async {
    emit(state.copyWith(status: TaskStatus.loading));
    await Future.delayed(Duration(seconds: 3));
    final result = await usecase.call(NoParams());
    if (result.isRight) {
      emit(state.copyWith(status: TaskStatus.success, data: result.right));
    } else {
      emit(state.copyWith(
          status: TaskStatus.error, errorText: result.left.message));
    }
  }

  // * isDone, title, priority -> faqat berilganlari yangilanadi
  Future<void> updateTask(
    String id, {
    bool? isDone,
    String? title,
    String? priority,
  }) async {
    final params = EditTaskParams(
      id: id,
      isDone: isDone,
      title: title,
      priority: priority,
    );
    final result = await editTaskUsecase.call(params);

    if (result.isRight) {
      final changes = params.toJson();
      final tasks = state.data.map((element) {
        if (element['documentId'] == id) {
          return {...element, ...changes};
        }
        return element;
      }).toList();
      emit(state.copyWith(data: tasks));
    } else {
      print('Error update data ${result.left.message}');
    }
  }

  Color checkStatus(String status) {
    if (status == 'low') {
      return AppColors.instance.green;
    } else if (status == 'medium') {
      return AppColors.instance.yellow;
    } else {
      return AppColors.instance.red;
    }
  }
}
