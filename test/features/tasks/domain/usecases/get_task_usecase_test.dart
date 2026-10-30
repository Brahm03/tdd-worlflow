import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/core/usecases/usecase.dart';
import 'package:task_app/core/utils/either.dart';
import 'package:task_app/features/tasks/domain/usecases/get_task_usecase.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/task_fixtures.dart';

void main() {
  late GetTaskUsecase usecase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = GetTaskUsecase(taskRepository: mockRepository);
  });

  test('should get tasks from the repository', () async {
    when(() => mockRepository.getTasks()).thenAnswer((_) async => Right(tTasks));

    final result = await usecase(NoParams());

    expect(result.right, tTasks);
    verify(() => mockRepository.getTasks()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
