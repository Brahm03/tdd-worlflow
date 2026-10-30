import 'package:injectable/injectable.dart';
import 'package:task_app/core/error/failures.dart';
import 'package:task_app/core/usecases/usecase.dart';
import 'package:task_app/core/utils/either.dart';
import 'package:task_app/features/tasks/domain/repositories/task_repository.dart';

@injectable
class GetAdsUsecase extends UseCase<List, NoParams> {
  final TaskRepository taskRepository;

  GetAdsUsecase({required this.taskRepository});

  @override
  Future<Either<Failure, List>> call(NoParams params) =>
      taskRepository.getAds();
}
