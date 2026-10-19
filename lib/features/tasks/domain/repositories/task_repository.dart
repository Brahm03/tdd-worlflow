import 'package:task_app/core/error/failures.dart';
import 'package:task_app/core/utils/either.dart';

abstract class TaskRepository {
  Future<Either<Failure, List>> getTasks();
  Future<Either<Failure, void>> updateTask(String id, Map<String, dynamic> data);
}