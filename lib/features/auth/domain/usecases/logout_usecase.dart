import 'package:injectable/injectable.dart';
import 'package:task_app/core/error/failures.dart';
import 'package:task_app/core/usecases/usecase.dart';
import 'package:task_app/core/utils/either.dart';
import 'package:task_app/features/auth/domain/repositories/auth_repository.dart';

@injectable
class LogoutUsecase extends UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    await repository.logout();
    return Right(null);
  }
}
