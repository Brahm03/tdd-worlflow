import 'package:mocktail/mocktail.dart';
import 'package:task_app/core/network/network_info.dart';
import 'package:task_app/features/tasks/data/datasources/task_remote_data_source.dart';
import 'package:task_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:task_app/features/tasks/domain/usecases/add_task.dart';
import 'package:task_app/features/tasks/domain/usecases/delete_task.dart';
import 'package:task_app/features/tasks/domain/usecases/get_tasks.dart';
import 'package:task_app/features/tasks/domain/usecases/update_task.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class MockTaskRemoteDataSource extends Mock implements TaskRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockGetTasks extends Mock implements GetTasks {}

class MockAddTask extends Mock implements AddTask {}

class MockUpdateTask extends Mock implements UpdateTask {}

class MockDeleteTask extends Mock implements DeleteTask {}
