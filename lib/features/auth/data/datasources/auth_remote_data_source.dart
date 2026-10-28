import "dart:io";

import "package:dio/dio.dart";
import "package:task_app/core/error/failures.dart";
import "package:task_app/core/utils/dio_model.dart";
import "package:task_app/core/utils/either.dart";
import "package:task_app/features/auth/data/models/auth_user_model.dart";

abstract class AuthDataSource {
  Future<Either<Failure, AuthUserModel>> login({
    required String identifier,
    required String password,
  });
  Future<Either<Failure, AuthUserModel>> register({
    required String username,
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl extends AuthDataSource {
  final DioModule client;

  AuthRemoteDataSourceImpl({DioModule? client})
      : client = client ?? DioModule();

  @override
  Future<Either<Failure, AuthUserModel>> login({
    required String identifier,
    required String password,
  }) =>
      _post('auth/local', {"identifier": identifier, "password": password});

  @override
  Future<Either<Failure, AuthUserModel>> register({
    required String username,
    required String email,
    required String password,
  }) =>
      _post('auth/local/register',
          {"username": username, "email": email, "password": password});

  Future<Either<Failure, AuthUserModel>> _post(
      String url, Map<String, dynamic> body) async {
    try {
      final response = await client.dio().post(url, data: body);
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        // * succes
        return Right(AuthUserModel.fromJson(response.data));
      }
      return Left(DioFailure(message: "Server ishlamayapti"));
    } on DioException catch (error) {
      print('Request url api ${error.requestOptions.uri}');
      print('Response data body ${error.requestOptions.data}');
      // * strapi xatosi: { error: { status, name, message } }
      final data = error.response?.data;
      if (data is Map && data['error'] is Map) {
        return Left(DioFailure(message: data['error']['message']));
      }
      if (error.type == DioExceptionType.connectionError) {
        return Left(NetworkFailure(message: "Serverga ulanib bo'lmadi"));
      }
      return Left(DioFailure(message: error.message));
    } on SocketException catch (_) {
      return Left(NetworkFailure(message: "Internet o'chiq"));
    } catch (error) {
      return Left(Failure(message: 'Something went wrong'));
    }
  }
}
