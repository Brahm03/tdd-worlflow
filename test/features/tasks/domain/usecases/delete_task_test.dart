import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/features/tasks/domain/usecases/delete_task.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late DeleteTask usecase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = DeleteTask(mockRepository);
  });

  test('should delete the task through the repository', () async {
    when(() => mockRepository.deleteTask('1'))
        .thenAnswer((_) async => const Right(unit));

    final result = await usecase(const DeleteTaskParams(id: '1'));

    expect(result, const Right(unit));
    verify(() => mockRepository.deleteTask('1')).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
