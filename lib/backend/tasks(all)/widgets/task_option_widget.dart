/* import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/todo_model.dart';

class TaskFilterOptionNotifier extends StateNotifier<TaskFilterOption> {
  TaskFilterOptionNotifier() : super(TaskFilterOption.category);

  void setFilterOption(TaskFilterOption option) {
    state = option;
  }
}

final taskFilterOptionProvider =
    StateNotifierProvider<TaskFilterOptionNotifier, TaskFilterOption>((ref) {
  return TaskFilterOptionNotifier();
});

TaskFilterOption selectedFilterOption = TaskFilterOption.category;

enum TaskFilterOption {
  category,
  date,
  completed,
  overdue,
  upcoming,
}

TaskFilterOption parseFilterOption(String? value) {
  switch (value) {
    case 'Category':
      return TaskFilterOption.category;
    case 'Date':
      return TaskFilterOption.date;
    case 'Completed':
      return TaskFilterOption.completed;
    case 'Upcoming':
      return TaskFilterOption.upcoming;
    case 'Overdue':
      return TaskFilterOption.overdue;
    default:
      return TaskFilterOption.category; // Set a default filter option
  }
}

List<ToDoModel> filterTasks(
    List<ToDoModel> tasks, TaskFilterOption selectedFilterOption) {
  switch (selectedFilterOption) {
    case TaskFilterOption.category:
      // Implement filtering by category
      // Example: return tasks.where((task) => task.category == selectedCategory).toList();
      break;
    case TaskFilterOption.date:
      // Implement filtering by date
      // Example: return tasks.where((task) => task.date.isBefore(DateTime.now())).toList();
      break;
    case TaskFilterOption.completed:
      // Implement filtering by completion status
      // Example: return tasks.where((task) => task.isCompleted).toList();
      break;
    case TaskFilterOption.overdue:
      // Implement filtering for overdue tasks
      // Example: return tasks.where((task) => task.date.isBefore(DateTime.now()) && !task.isCompleted).toList();
      break;
    case TaskFilterOption.upcoming:
      // Implement filtering for upcoming tasks
      // Example: return tasks.where((task) => task.date.isAfter(DateTime.now()) && !task.isCompleted).toList();
      break;
  }
  return tasks;
}

// ignore: must_be_immutable
class TaskFilterByWidget extends ConsumerWidget {
  TaskFilterByWidget({super.key});

  var taskFilterByItems = [
    {'label': 'Category', 'value': TaskFilterOption.category},
    {'label': 'Date', 'value': TaskFilterOption.date},
    {'label': 'Completed', 'value': TaskFilterOption.completed},
    {'label': 'Upcoming', 'value': TaskFilterOption.upcoming},
    {'label': 'Overdue', 'value': TaskFilterOption.overdue},
  ] as List<Map<String, TaskFilterOption>>;

  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilterOption = ref.watch(taskFilterOptionProvider);
    return DropdownButton<TaskFilterOption>(
      isExpanded: false,
      focusColor: Colors.white,
      value: selectedFilterOption,
      style: const TextStyle(color: Colors.white),
      iconEnabledColor: Colors.blue,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      items: taskFilterByItems.map((item) {
        return DropdownMenuItem<TaskFilterOption>(
          value: TaskFilterOption.category,
          child: Text(item as String),
        );
      }).toList(),
      hint: const Text(
        "Filter By",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      onChanged: (TaskFilterOption? option) {
        if (option != null) {
          ref.read(taskFilterOptionProvider.notifier).setFilterOption(option);
        }
      },
    );
  }
}

*/