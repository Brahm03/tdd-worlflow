import 'package:flutter/material.dart';

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      // TODO: open a form and call TasksCubit.createTask
      onPressed: null,
      child: const Icon(Icons.add),
    );
  }
}
