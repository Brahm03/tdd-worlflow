import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String? message;

  const Failure({this.message});

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message});
}

class DioFailure extends Failure {
  const DioFailure({super.message});
}
