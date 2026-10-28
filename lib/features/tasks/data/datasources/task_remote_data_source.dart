import "dart:async";
import "dart:io";

import "package:dio/dio.dart";
import "package:task_app/core/error/failures.dart";
import "package:task_app/core/storage/token_storage.dart";
import "package:task_app/core/utils/dio_model.dart";
import "package:task_app/core/utils/either.dart";

abstract class TaskDataSource {
  // * ota class -> api funksiyalarni bosh ushlaydi

  Future<Either<Failure, List>> getAds();

  Future<Either<Failure, List>> getTasks();
  Future<Either<Failure, void>> updateTask(
      String id, Map<String, dynamic> data);
}

class TaskRemoteDataSourceImpl extends TaskDataSource {
  // * login/register paytida saqlangan jwt

  DioModule client = DioModule();

  @override
  Future<Either<Failure, List>> getTasks() async {
    try {
      final response = await client.dio().get("tasks");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        // * succes
        return Right(response.data['data']);
      }

      if (response.statusCode == 403) {
        return Left(Failure(
            message: 'You need to sign up or login to account first !'));
      }

      return Left(DioFailure(message: "Server ishlamayapti"));
    } on DioException catch (error) {
      if (error.response?.statusCode == 403) {
        return Left(Failure(
            message: 'You need to sign up or login to account first !'));
      }
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
      final response = await client.dio().put(
        'tasks/$id',
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

  @override
  Future<Either<Failure, List>> getAds() async {
    try {
      final accessToken = TokenStorage.instance.token;

      if (accessToken == null) {
        return Left(Failure(
            message: 'You need to sign up or login to account first !'));
      }

      // * Authorization headerni AuthInterceptor qo'shadi
      final response = await client.dio().get("reklamas?populate=image");

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return Right(response.data['data']);
      }
      return Left(DioFailure(message: "Server ishlamayapti"));
    } on DioException catch (error) {
      return Left(DioFailure(message: error.message));
    } on TimeoutException catch (_) {
      return Left(NetworkFailure(message: "Retry again"));
    } on SocketException catch (_) {
      return Left(NetworkFailure(message: "Internet o'chiq"));
    } catch (error) {
      return Left(Failure(message: 'Something went wrong'));
    }
  }
}

