import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../taskmodels/task_model.dart';
import '../../widgets/category_widget_all/category.model.dart';
import 'selected_category_providers.dart';
import 'service_provider.dart';

//notifier providers

class TaskListNotifier extends StateNotifier<List<TaskModel>> {
  TaskListNotifier() : super([]);

  void updateTasks(List<TaskModel> tasks) async {
    state = tasks;
  }

  void removeTask(TaskModel task) {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    state = state.where((item) => item.docID != task.docID).toList();
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Categories')
        .doc(task.categoryID)
        .collection('Tasks')
        .doc(task.docID)
        .delete();
  }
}

//services

final taskListProvider =
    StateNotifierProvider<TaskListNotifier, List<TaskModel>>(
        (ref) => TaskListNotifier());

final serviceProvider = StateProvider<ToDoService>((ref) {
  return ToDoService();
});

var taskUpdateStateProvider = StateProvider<TaskModel>((ref) {
  return TaskModel(
      taskTitle: '',
      description: '',
      dateTask: '',
      timeTask: '',
      isDone: false,
      status: '',
      categoryID: '',
      categoryName: '',
      categoryColorHex: '',
      repeatShown: '',
      repeatingDays: [],
      repeatingFrequency: '',
      creationDate: '',
      stopDate: '');
});

class ToDoService {
  final users = FirebaseFirestore.instance.collection('users');

  // CRUD

  // CREATE

  Future<DocumentReference<Object?>> addNewTask(
      WidgetRef ref, TaskModel model, String userID, String categoryID) async {
    final addedTaskReference = await users
        .doc(userID)
        .collection('Categories')
        .doc(categoryID)
        .collection('Tasks')
        .add(model.toJson());

    final taskIDMake = addedTaskReference.id;

    ref.read(serviceProvider).updateTask(
        ref,
        categoryID,
        TaskModel(
            docID: taskIDMake,
            taskTitle: model.taskTitle,
            description: model.description,
            categoryID: categoryID,
            categoryName: model.categoryName,
            categoryColorHex: model.categoryColorHex,
            dateTask: model.dateTask,
            timeTask: model.timeTask,
            isDone: model.isDone,
            status: model.status,
            repeatShown: model.repeatShown,
            repeatingDays: model.repeatingDays,
            repeatingFrequency: model.repeatingFrequency,
            stopDate: model.stopDate,
            creationDate: model.creationDate));

    return addedTaskReference;
  }

  // UPDATE

  void updateTasksList(WidgetRef ref, TaskModel updatedTask) {
    final tasksToUpdate = ref.read(taskListProvider);
    final updatedTasks = <TaskModel>[];

    for (var task in tasksToUpdate) {
      if (task.docID == updatedTask.docID) {
        updatedTasks.add(updatedTask);
      } else {
        updatedTasks.add(task);
      }
    }

    ref
        .read(taskListProvider.notifier)
        .updateTasks([...ref.read(taskListProvider)]);
  }

  Future<void> updateTask(
    WidgetRef ref,
    String categoryID,
    TaskModel model,
  ) async {
    try {
      final taskReference = users
          .doc(userID)
          .collection('Categories')
          .doc(categoryID)
          .collection('Tasks')
          .doc(model.docID);

      await taskReference.update(model.toJson());

      ref.read(taskUpdateStateProvider.notifier).state = model;
    } catch (e) {
      return;
    }
  }

  void updateDoneTask(
      String userID, String categoryID, String taskID, bool? valueUpdate) {
    users
        .doc(userID)
        .collection('Categories')
        .doc(categoryID)
        .collection('Tasks')
        .doc(taskID)
        .update({'isDone': valueUpdate});
  }

  Future<void> updateTasksColorForCategory(
      WidgetRef ref, UserCreatedCategoryModel updatedCategory) async {
    final tasksToUpdate = ref.read(taskListProvider);

    final updatedTasks = <TaskModel>[];

    for (var task in tasksToUpdate) {
      if (task.categoryID == updatedCategory.categoryID) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .collection('Categories')
            .doc(task.categoryID)
            .collection('Tasks')
            .doc(task.docID)
            .update({'categoryColorHex': updatedCategory.colorHex});

        final updatedTask =
            task.copyWith(categoryColorHex: updatedCategory.colorHex);
        updatedTasks.add(updatedTask);
      } else {
        updatedTasks.add(task);
      }
    }
    ref.read(taskListProvider.notifier).updateTasks(updatedTasks);
  }
}

updateProviders(TaskModel task, WidgetRef ref) async {
  final List<String> fireDaysList = [];
  fireDaysList.addAll(task.repeatingDays);
  if (kDebugMode) {
    print(fireDaysList);
  }
  ref.read(selectedCategoryProvider.notifier).state = UserCreatedCategoryModel(
    categoryID: task.categoryID,
    categoryName: task.categoryName,
    colorHex: task.categoryColorHex,
  );
  ref.read(repeatingOptionDays.notifier).update((state) => fireDaysList);
  ref
      .read(repeatingOptionFrequency.notifier)
      .update((state) => task.repeatingFrequency);
  ref.read(stopDateProvider.notifier).update((state) => task.stopDate);
  ref.read(repeatShownProvider.notifier).update((state) => task.repeatShown);
}
