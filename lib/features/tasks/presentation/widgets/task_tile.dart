import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  // * strapi task: { documentId, title, isDone, date, priority }
  final Map<String, dynamic> task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    // TODO: wire onChanged -> TasksCubit.updateTask
    return ListTile(
      title: Text(task['title'] ?? ''),
      subtitle: Text(task['priority'] ?? ''),
    );
  }
}
