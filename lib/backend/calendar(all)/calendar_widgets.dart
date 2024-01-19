import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../tasks(all)/taskmodels/new_task_model.dart';

class CalendarTaskButton extends HookConsumerWidget {
  const CalendarTaskButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet<void>(
          showDragHandle: true,
          isDismissible: false,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          context: context,
          builder: (context) => const AddNewTaskModel(),
        ).whenComplete(() => null);
      },
      child: const Text(
        '+ New Task',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
