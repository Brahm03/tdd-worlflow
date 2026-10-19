import "dart:io";

import "package:dio/dio.dart";
import "package:task_app/core/error/failures.dart";
import "package:task_app/core/utils/either.dart";

abstract class TaskDataSource {
  // * ota class -> api funksiyalarni bosh ushlaydi
  Future<Either<Failure, List>> getTasks();
  Future<Either<Failure, void>> updateTask(
      String id, Map<String, dynamic> data);
}

class TaskRemoteDataSourceImpl extends TaskDataSource {
  @override
  Future<Either<Failure, List>> getTasks() async {
    try {
      final response = await Dio().get("http://localhost:1337/api/tasks");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        // * succes
        return Right(response.data['data']);
      }

      return Left(DioFailure(message: "Server ishlamayapti"));
    } on DioException catch (error) {
      return Left(DioFailure(message: error.message));
    } on SocketException catch (_) {
      return Left(NetworkFailure(message: "Internet o'chiq"));
    } catch (error) {
      return Left(Failure(message: 'Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, void>> updateTask(
      String id, Map<String, dynamic> data) async {
    try {
      print('ID ${'http://localhost:1337/api/tasks/$id'}');
      print("Data $data");
      final response = await Dio().put(
        'http://localhost:1337/api/tasks/$id',
        data: {"data": data},
      );
  
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        // * succes
        return Right(null);
      }

      return Left(DioFailure(message: "Server ishlamayapti"));
    } on DioException catch (error) {
      return Left(DioFailure(message: error.message));
    } on SocketException catch (_) {
      return Left(NetworkFailure(message: "Internet o'chiq"));
    } catch (error) {
      return Left(Failure(message: 'Something went wrong'));
    }
  }
}
