import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/core/error/failures.dart';
import 'package:task_app/core/usecases/usecase.dart';
import 'package:task_app/core/utils/either.dart';
import 'package:task_app/features/tasks/domain/usecases/edit_task_usecase.dart';
import 'package:task_app/features/tasks/presentation/bloc/tasks_cubit.dart';
import 'package:task_app/features/tasks/presentation/bloc/tasks_state.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/task_fixtures.dart';

// * TasksState Equatable emas, shuning uchun maydonlarini solishtiramiz
Matcher isState(TaskStatus status, {List? data, String? errorText}) =>
    isA<TasksState>()
        .having((s) => s.status, 'status', status)
        .having((s) => s.data, 'data', data ?? anything)
        .having((s) => s.errorText, 'errorText', errorText);

void main() {
  late MockGetTaskUsecase mockGetTask;
  late MockEditTaskUsecase mockEditTask;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(EditTaskParams(id: ''));
  });

  setUp(() {
    mockGetTask = MockGetTaskUsecase();
    mockEditTask = MockEditTaskUsecase();
  });

  TasksCubit buildCubit() =>
      TasksCubit(usecase: mockGetTask, editTaskUsecase: mockEditTask);

  test('initial state is loading', () {
    expect(buildCubit().state.status, TaskStatus.loading);
  });

  group('getTask', () {
    blocTest<TasksCubit, TasksState>(
      'emits [loading, success] when fetch succeeds',
      build: () {
        when(() => mockGetTask(any())).thenAnswer((_) async => Right(tTasks));
        return buildCubit();
      },
      act: (cubit) => cubit.getTask(),
      expect: () => [
        isState(TaskStatus.loading),
        isState(TaskStatus.success, data: tTasks),
      ],
    );

    blocTest<TasksCubit, TasksState>(
      'emits [loading, error] when fetch fails',
      build: () {
        when(() => mockGetTask(any())).thenAnswer(
            (_) async => Left(const NetworkFailure(message: "Internet o'chiq")));
        return buildCubit();
      },
      act: (cubit) => cubit.getTask(),
      expect: () => [
        isState(TaskStatus.loading),
        isState(TaskStatus.error, errorText: "Internet o'chiq"),
      ],
    );
  });

  group('updateTask', () {
    blocTest<TasksCubit, TasksState>(
      'merges changes into the matching task on success',
      build: () {
        when(() => mockEditTask(any())).thenAnswer((_) async => Right(null));
        return buildCubit();
      },
      seed: () => TasksState(status: TaskStatus.success, data: tTasks),
      act: (cubit) => cubit.updateTask('abc123', isDone: true),
      expect: () => [
        isState(TaskStatus.success, data: [
          {...tTask, 'isDone': true},
        ]),
      ],
    );

    blocTest<TasksCubit, TasksState>(
      'emits nothing when update fails',
      build: () {
        when(() => mockEditTask(any())).thenAnswer(
            (_) async => Left(const DioFailure(message: 'Server ishlamayapti')));
        return buildCubit();
      },
      seed: () => TasksState(status: TaskStatus.success, data: tTasks),
      act: (cubit) => cubit.updateTask('abc123', isDone: true),
      expect: () => [],
    );
  });
}
