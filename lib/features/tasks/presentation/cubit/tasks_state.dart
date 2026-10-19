enum TaskStatus { loading, error, success, failure }

class TasksState {
  final TaskStatus status;
  final String? errorText;
  final List data;

  TasksState({
    required this.status,
    this.data = const [],
    this.errorText,
  });

  TasksState copyWith({
    TaskStatus? status,
    String? errorText,
    List? data,
  }) {
    return TasksState(
      status: status ?? this.status,
      errorText: errorText ?? this.errorText,
      data: data ?? this.data,
    );
  }
}
