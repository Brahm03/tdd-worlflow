import 'package:equatable/equatable.dart';
import 'package:task_app/core/utils/either.dart';

import '../error/failures.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
