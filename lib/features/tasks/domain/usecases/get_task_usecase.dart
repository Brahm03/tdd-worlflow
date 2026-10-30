import 'package:injectable/injectable.dart';
import 'package:task_app/core/error/failures.dart';
import 'package:task_app/core/usecases/usecase.dart';
import 'package:task_app/core/utils/either.dart';
import 'package:task_app/features/tasks/domain/repositories/task_repository.dart';

// * T -> funksiya success bolsa nima jonatishi
// * Params -> funksiya params bolsa nima jonatishi
@injectable
class GetTaskUsecase extends UseCase<List, NoParams> {
  final TaskRepository taskRepository;

  GetTaskUsecase({required this.taskRepository});

  @override
  Future<Either<Failure, List>> call(NoParams params) =>
      taskRepository.getTasks();
}
