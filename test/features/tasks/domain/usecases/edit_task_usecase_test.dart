import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/core/utils/either.dart';
import 'package:task_app/features/tasks/domain/usecases/edit_task_usecase.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late EditTaskUsecase usecase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = EditTaskUsecase(repository: mockRepository);
  });

  test('sends only the changed fields to the repository', () async {
    when(() => mockRepository.updateTask(any(), any()))
        .thenAnswer((_) async => Right(null));

    final result = await usecase(EditTaskParams(id: 'abc123', isDone: true));

    expect(result.isRight, true);
    verify(() => mockRepository.updateTask('abc123', {'isDone': true}))
        .called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('EditTaskParams.toJson skips null fields', () {
    expect(
      EditTaskParams(id: '1', title: 'New', priority: 'high').toJson(),
      {'title': 'New', 'priority': 'high'},
    );
  });
}
