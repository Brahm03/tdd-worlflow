import 'package:task_app/core/error/failures.dart';
import 'package:task_app/core/utils/either.dart';
import 'package:task_app/features/tasks/data/datasources/task_remote_data_source.dart';
import 'package:task_app/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImple extends TaskRepository {
  final TaskDataSource dataSource;

  TaskRepositoryImple({required this.dataSource});

  @override
  Future<Either<Failure, List>> getTasks() async {
    final result = await dataSource.getTasks();
    if (result.isRight) {
      return Right(result.right);
    } else {
      return Left(result.left);
    }
  }

  @override
  Future<Either<Failure, void>> updateTask(
      String id, Map<String, dynamic> data) async {
    final result = await dataSource.updateTask(id, data);
    if (result.isRight) {
      return Right(result.right);
    } else {
      return Left(result.left);
    }
  }

  @override
  Future<Either<Failure, List>> getAds() async {
    final result = await dataSource.getAds();
    if (result.isRight) {
      return Right(result.right);
    } else {
      return Left(result.left);
    }
  }
}
