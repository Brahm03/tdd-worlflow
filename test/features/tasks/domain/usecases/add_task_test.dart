import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/features/tasks/domain/usecases/add_task.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/task_fixtures.dart';

void main() {
  late AddTask usecase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = AddTask(mockRepository);
  });

  test('should add a task through the repository', () async {
    when(() => mockRepository.addTask(
          title: any(named: 'title'),
          description: any(named: 'description'),
        )).thenAnswer((_) async => Right(tTask));

    final result = await usecase(
      AddTaskParams(title: tTask.title, description: tTask.description),
    );

    expect(result, Right(tTask));
    verify(() => mockRepository.addTask(
          title: tTask.title,
          description: tTask.description,
        )).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
