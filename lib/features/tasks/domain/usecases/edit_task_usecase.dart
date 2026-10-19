import 'package:task_app/core/error/failures.dart';
import 'package:task_app/core/usecases/usecase.dart';
import 'package:task_app/core/utils/either.dart';
import 'package:task_app/features/tasks/domain/repositories/task_repository.dart';

class EditTaskUsecase extends UseCase<void, EditTaskParams> {
  final TaskRepository repository;

  EditTaskUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(EditTaskParams params) async {
    return await repository.updateTask(params.id, params.toJson());
  }
}

// * faqat o'zgargan maydonlar serverga jonatiladi
class EditTaskParams {
  final String id;
  final bool? isDone;
  final String? title;
  final String? priority; // low | medium | high

  EditTaskParams({
    required this.id,
    this.isDone,
    this.title,
    this.priority,
  });

  Map<String, dynamic> toJson() {
    return {
      if (isDone != null) 'isDone': isDone,
      if (title != null) 'title': title,
      if (priority != null) 'priority': priority,
    };
  }
}
