import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/core/error/exceptions.dart';
import 'package:task_app/core/error/failures.dart';
import 'package:task_app/features/tasks/data/repositories/task_repository_impl.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/task_fixtures.dart';

void main() {
  late TaskRepositoryImpl repository;
  late MockTaskRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockTaskRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TaskRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void online() =>
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
  void offline() =>
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

  group('getTasks', () {
    test('returns Right(tasks) when online and call succeeds', () async {
      online();
      when(() => mockRemoteDataSource.getTasks())
          .thenAnswer((_) async => tTaskModels);

      final result = await repository.getTasks();

      expect(result, Right(tTaskModels));
    });

    test('returns Left(ServerFailure) when call throws ServerException',
        () async {
      online();
      when(() => mockRemoteDataSource.getTasks()).thenThrow(ServerException());

      final result = await repository.getTasks();

      expect(result, Left(ServerFailure()));
    });

    test('returns Left(NetworkFailure) when offline', () async {
      offline();

      final result = await repository.getTasks();

      expect(result, Left(NetworkFailure()));
      verifyZeroInteractions(mockRemoteDataSource);
    });
  });

  group('addTask', () {
    test('returns Right(task) when online and call succeeds', () async {
      online();
      when(() => mockRemoteDataSource.addTask(
            title: tTask.title,
            description: tTask.description,
          )).thenAnswer((_) async => tTaskModel);

      final result = await repository.addTask(
        title: tTask.title,
        description: tTask.description,
      );

      expect(result, Right(tTaskModel));
    });

    test('returns Left(ServerFailure) when call throws ServerException',
        () async {
      online();
      when(() => mockRemoteDataSource.addTask(
            title: any(named: 'title'),
            description: any(named: 'description'),
          )).thenThrow(ServerException());

      final result = await repository.addTask(
        title: tTask.title,
        description: tTask.description,
      );

      expect(result, Left(ServerFailure()));
    });

    test('returns Left(NetworkFailure) when offline', () async {
      offline();

      final result = await repository.addTask(
        title: tTask.title,
        description: tTask.description,
      );

      expect(result, Left(NetworkFailure()));
      verifyZeroInteractions(mockRemoteDataSource);
    });
  });

  group('updateTask', () {
    setUpAll(() => registerFallbackValue(tTaskModel));

    test('returns Right(task) when online and call succeeds', () async {
      online();
      when(() => mockRemoteDataSource.updateTask(any()))
          .thenAnswer((_) async => tTaskModel);

      final result = await repository.updateTask(tTask);

      expect(result, Right(tTaskModel));
    });

    test('returns Left(ServerFailure) when call throws ServerException',
        () async {
      online();
      when(() => mockRemoteDataSource.updateTask(any()))
          .thenThrow(ServerException());

      final result = await repository.updateTask(tTask);

      expect(result, Left(ServerFailure()));
    });

    test('returns Left(NetworkFailure) when offline', () async {
      offline();

      final result = await repository.updateTask(tTask);

      expect(result, Left(NetworkFailure()));
      verifyZeroInteractions(mockRemoteDataSource);
    });
  });

  group('deleteTask', () {
    test('returns Right(unit) when online and call succeeds', () async {
      online();
      when(() => mockRemoteDataSource.deleteTask('1')).thenAnswer((_) async {});

      final result = await repository.deleteTask('1');

      expect(result, const Right(unit));
    });

    test('returns Left(ServerFailure) when call throws ServerException',
        () async {
      online();
      when(() => mockRemoteDataSource.deleteTask('1'))
          .thenThrow(ServerException());

      final result = await repository.deleteTask('1');

      expect(result, Left(ServerFailure()));
    });

    test('returns Left(NetworkFailure) when offline', () async {
      offline();

      final result = await repository.deleteTask('1');

      expect(result, Left(NetworkFailure()));
      verifyZeroInteractions(mockRemoteDataSource);
    });
  });
}
