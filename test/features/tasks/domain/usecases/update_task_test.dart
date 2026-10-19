import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/features/tasks/domain/usecases/update_task.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/task_fixtures.dart';

void main() {
  late UpdateTask usecase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = UpdateTask(mockRepository);
  });

  test('should update the task through the repository', () async {
    when(() => mockRepository.updateTask(tTask))
        .thenAnswer((_) async => Right(tTask));

    final result = await usecase(UpdateTaskParams(task: tTask));

    expect(result, Right(tTask));
    verify(() => mockRepository.updateTask(tTask)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
