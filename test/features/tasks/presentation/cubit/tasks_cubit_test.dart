import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/core/error/failures.dart';
import 'package:task_app/core/usecases/usecase.dart';
import 'package:task_app/features/tasks/presentation/bloc/tasks_cubit.dart';
import 'package:task_app/features/tasks/presentation/bloc/tasks_state.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/task_fixtures.dart';

void main() {
  late MockGetTasks mockGetTasks;
  late MockAddTask mockAddTask;
  late MockUpdateTask mockUpdateTask;
  late MockDeleteTask mockDeleteTask;

  setUpAll(() => registerFallbackValue(NoParams()));

  setUp(() {
    mockGetTasks = MockGetTasks();
    mockAddTask = MockAddTask();
    mockUpdateTask = MockUpdateTask();
    mockDeleteTask = MockDeleteTask();
  });

  TasksCubit buildCubit() => TasksCubit(
        getTasks: mockGetTasks,
        addTask: mockAddTask,
        updateTask: mockUpdateTask,
        deleteTask: mockDeleteTask,
      );

  test('initial state is TasksInitial', () {
    expect(buildCubit().state, const TasksInitial());
  });

  group('loadTasks', () {
    blocTest<TasksCubit, TasksState>(
      'emits [TasksLoading, TasksLoaded] when fetch succeeds',
      build: () {
        when(() => mockGetTasks(any())).thenAnswer((_) async => Right(tTasks));
        return buildCubit();
      },
      act: (cubit) => cubit.loadTasks(),
      expect: () => [const TasksLoading(), TasksLoaded(tTasks)],
    );

    blocTest<TasksCubit, TasksState>(
      'emits [TasksLoading, TasksError] on ServerFailure',
      build: () {
        when(() => mockGetTasks(any()))
            .thenAnswer((_) async => Left(ServerFailure()));
        return buildCubit();
      },
      act: (cubit) => cubit.loadTasks(),
      expect: () => [
        const TasksLoading(),
        const TasksError('Server error, please try again.'),
      ],
    );

    blocTest<TasksCubit, TasksState>(
      'emits [TasksLoading, TasksError] on NetworkFailure',
      build: () {
        when(() => mockGetTasks(any()))
            .thenAnswer((_) async => Left(NetworkFailure()));
        return buildCubit();
      },
      act: (cubit) => cubit.loadTasks(),
      expect: () => [
        const TasksLoading(),
        const TasksError('No internet connection.'),
      ],
    );
  });

  // TODO: add blocTests for createTask, toggleTask and removeTask once their
  // expected state transitions are decided.
}
