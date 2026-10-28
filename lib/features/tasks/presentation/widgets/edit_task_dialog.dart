import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/tasks_cubit.dart';

const priorities = ['low', 'medium', 'high'];

Future<void> showEditTaskDialog(
  BuildContext context, {
  required TasksCubit cubit,
  required Map task,
}) {
  return showDialog(
    context: context,
    builder: (_) => EditTaskDialog(cubit: cubit, task: task),
  );
}

class EditTaskDialog extends StatefulWidget {
  final TasksCubit cubit;
  final Map task;

  const EditTaskDialog({super.key, required this.cubit, required this.task});

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late final TextEditingController titleController =
      TextEditingController(text: widget.task['title']);
  late String priority = widget.task['priority'] ?? 'low';

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  void save() {
    final title = titleController.text.trim();
    if (title.isEmpty) return;

    // * faqat o'zgargan maydonlarni jonatamiz
    widget.cubit.updateTask(
      widget.task['documentId'],
      title: title != widget.task['title'] ? title : null,
      priority: priority != widget.task['priority'] ? priority : null,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Edit task',
        style: GoogleFonts.montserratAlternates(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          TextField(
            controller: titleController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Task name'),
          ),
          Wrap(
            spacing: 8,
            children: priorities.map((p) {
              return ChoiceChip(
                label: Text(p),
                selected: priority == p,
                selectedColor: widget.cubit.checkStatus(p),
                onSelected: (_) => setState(() => priority = p),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(onPressed: save, child: const Text('Save')),
      ],
    );
  }
}
