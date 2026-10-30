import 'package:mocktail/mocktail.dart';
import 'package:task_app/features/tasks/data/datasources/task_remote_data_source.dart';
import 'package:task_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:task_app/features/tasks/domain/usecases/edit_task_usecase.dart';
import 'package:task_app/features/tasks/domain/usecases/get_ads_usecase.dart';
import 'package:task_app/features/tasks/domain/usecases/get_task_usecase.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class MockTaskDataSource extends Mock implements TaskDataSource {}

class MockGetTaskUsecase extends Mock implements GetTaskUsecase {}

class MockEditTaskUsecase extends Mock implements EditTaskUsecase {}

class MockGetAdsUsecase extends Mock implements GetAdsUsecase {}
