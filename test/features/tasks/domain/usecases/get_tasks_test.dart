import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/core/usecases/usecase.dart';
import 'package:task_app/features/tasks/domain/usecases/get_tasks.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/task_fixtures.dart';

void main() {
  late GetTasks usecase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = GetTasks(mockRepository);
  });

  test('should get tasks from the repository', () async {
    when(() => mockRepository.getTasks()).thenAnswer((_) async => Right(tTasks));

    final result = await usecase(NoParams());

    expect(result, Right(tTasks));
    verify(() => mockRepository.getTasks()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
