import 'package:flutter/material.dart';


class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    // TODO: wire onChanged -> TasksCubit.toggleTask, onDismissed -> removeTask
    return ListTile(
      title: Text(task.title),
      subtitle: Text(task.description),
    );
  }
}
