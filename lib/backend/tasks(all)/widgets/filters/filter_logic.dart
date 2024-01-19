import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../taskmodels/task_model.dart';

final user = FirebaseAuth.instance.currentUser?.uid;

class FilterStates {
  final format = DateFormat.yMEd();

  //all

  List<TaskModel> clearSort(
    List<TaskModel> tasks,
  ) {
    return tasks;
  }

  // Category
  void sortByCategory(List<TaskModel> tasks, String category) {
    if (category != 'No Category') {
      tasks.sort((a, b) => b.creationDate.compareTo(a.creationDate));
    }
  }

// Completed
  void sortByCompleted(List<TaskModel> tasks) {
    var dateList = <DateTime>[];
    for (var task in tasks) {
      final DateTime creationTime = format.parse(task.creationDate);
      dateList.add(creationTime);
    }
    dateList.sort((a, b) => a.compareTo(b));

    var tasksIndex = 0;
    for (var creationTime in dateList) {
      tasks[tasksIndex++] = tasks
          .firstWhere((task) => task.creationDate == creationTime.toString());
    }
  }

// Date
  void sortByDate(List<TaskModel> tasks) {
    var dateList = <DateTime>[];
    for (var task in tasks) {
      final DateTime taskTime = format.parse(task.dateTask);
      dateList.add(taskTime);
    }
    dateList.sort((a, b) => a.compareTo(b));

    var tasksIndex = 0;
    for (var taskTime in dateList) {
      final format = DateFormat.yMEd();
      final String taskDate = format.format(taskTime);
      tasks[tasksIndex++] =
          tasks.firstWhere((task) => task.dateTask == taskDate);
    }
  }

// New->Old
  void sortNewestToOldest(List<TaskModel> tasks) {
    var taskCreationList = <DateTime>[];
    for (var task in tasks) {
      final DateTime creationTime = format.parse(task.creationDate);
      taskCreationList.add(creationTime);
    }
    taskCreationList.sort((a, b) => a.compareTo(b));

    var tasksIndex = 0;
    for (var creationTime in taskCreationList) {
      final format = DateFormat.yMEd();
      final String createdDate = format.format(creationTime);
      tasks[tasksIndex++] =
          tasks.firstWhere((task) => task.creationDate == createdDate);
    }
  }

// Old->New
  void sortOldestToNewest(List<TaskModel> tasks) {
    var taskCreationList = <DateTime>[];
    for (var task in tasks) {
      final DateTime creationTime = format.parse(task.creationDate);
      taskCreationList.add(creationTime);
    }
    taskCreationList.sort((a, b) => a.compareTo(b));

    var tasksIndex = 0;
    for (var creationTime in taskCreationList.reversed) {
      final format = DateFormat.yMEd();
      final String createdDate = format.format(creationTime);
      tasks[tasksIndex++] =
          tasks.firstWhere((task) => task.creationDate == createdDate);
    }
  }

// Overdue(Checked)
  void sortByOverdue(List<TaskModel> tasks) {
    final today = DateTime.now();
    tasks.retainWhere((task) {
      final DateTime dateOfTask = format.parse(task.dateTask);
      return dateOfTask.isBefore(today);
    });
    tasks.sort((a, b) => a.dateTask.compareTo(b.dateTask));
  }

// Upcoming(Checked)
  void sortByUpcoming(List<TaskModel> tasks) {
    final today = DateTime.now();
    tasks.retainWhere((task) {
      final DateTime dateOfTask = format.parse(task.dateTask);
      return dateOfTask.isAfter(today);
    });
    tasks.sort((a, b) => a.dateTask.compareTo(b.dateTask));
  }
}
