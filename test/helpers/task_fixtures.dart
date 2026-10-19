import 'package:task_app/features/tasks/data/models/task_model.dart';
import 'package:task_app/features/tasks/domain/entities/task.dart';

final tCreatedAt = DateTime(2026, 1, 1);

final tTask = Task(
  id: '1',
  title: 'Test task',
  description: 'Description',
  isCompleted: false,
  createdAt: tCreatedAt,
);

final tTaskModel = TaskModel(
  id: '1',
  title: 'Test task',
  description: 'Description',
  isCompleted: false,
  createdAt: tCreatedAt,
);

final tTasks = [tTask];
final tTaskModels = [tTaskModel];
