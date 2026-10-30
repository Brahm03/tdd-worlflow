import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/core/error/failures.dart';
import 'package:task_app/core/utils/either.dart';
import 'package:task_app/features/tasks/data/repositories/task_repository_impl.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/task_fixtures.dart';

void main() {
  late TaskRepositoryImple repository;
  late MockTaskDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockTaskDataSource();
    repository = TaskRepositoryImple(dataSource: mockDataSource);
  });

  group('getTasks', () {
    test('returns Right(tasks) when data source succeeds', () async {
      when(() => mockDataSource.getTasks())
          .thenAnswer((_) async => Right(tTasks));

      final result = await repository.getTasks();

      expect(result.right, tTasks);
    });

    test('returns Left(failure) when data source fails', () async {
      when(() => mockDataSource.getTasks()).thenAnswer(
          (_) async => Left(const NetworkFailure(message: "Internet o'chiq")));

      final result = await repository.getTasks();

      expect(result.left, const NetworkFailure(message: "Internet o'chiq"));
    });
  });

  group('updateTask', () {
    test('returns Right when data source succeeds', () async {
      when(() => mockDataSource.updateTask('abc123', {'isDone': true}))
          .thenAnswer((_) async => Right(null));

      final result = await repository.updateTask('abc123', {'isDone': true});

      expect(result.isRight, true);
      verify(() => mockDataSource.updateTask('abc123', {'isDone': true}))
          .called(1);
    });

    test('returns Left(failure) when data source fails', () async {
      when(() => mockDataSource.updateTask(any(), any())).thenAnswer(
          (_) async => Left(const DioFailure(message: 'Server ishlamayapti')));

      final result = await repository.updateTask('abc123', {'isDone': true});

      expect(result.left, const DioFailure(message: 'Server ishlamayapti'));
    });
  });

  group('getAds', () {
    test('returns Right(ads) when data source succeeds', () async {
      when(() => mockDataSource.getAds()).thenAnswer((_) async => Right([]));

      final result = await repository.getAds();

      expect(result.right, []);
    });

    test('returns Left(failure) when data source fails', () async {
      when(() => mockDataSource.getAds())
          .thenAnswer((_) async => Left(const Failure(message: 'error')));

      final result = await repository.getAds();

      expect(result.left, const Failure(message: 'error'));
    });
  });
}
