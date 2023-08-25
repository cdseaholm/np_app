import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_app/backend/tasks(all)/widgets/category_widget_all/category.model.dart';
import '../../taskmodels/task_model.dart';

class CategoryListNotifier
    extends StateNotifier<List<UserCreatedCategoryModel>> {
  CategoryListNotifier() : super([]);

  Future<void> updateCategoriesState(
      List<UserCreatedCategoryModel> categories) async {
    state = categories;
  }

  Future<void> removeCategoriesState(UserCreatedCategoryModel category) async {
    state =
        state.where((item) => item.categoryID != category.categoryID).toList();
  }

  Future<void> updateCategoryState(
      UserCreatedCategoryModel updatedCategory) async {
    if (kDebugMode) {
      print('Updating category state...');
    }
    state = state.map((category) {
      if (category.categoryID == updatedCategory.categoryID) {
        return updatedCategory;
      }
      return category;
    }).toList();
  }
}

final categoryProvider =
    StateNotifierProvider<CategoryListNotifier, List<UserCreatedCategoryModel>>(
        (ref) => CategoryListNotifier());

class TaskListNotifier extends StateNotifier<List<TaskModel>> {
  TaskListNotifier() : super([]);

  void updateTasks(List<TaskModel> tasks) {
    state = tasks;
  }

  void removeTask(TaskModel task) {
    state = state.where((item) => item.docID != task.docID).toList();
  }
}

final taskListProvider =
    StateNotifierProvider<TaskListNotifier, List<TaskModel>>(
        (ref) => TaskListNotifier());

final fetchCategoryTasks =
    StreamProvider.autoDispose<List<TaskModel>>((ref) async* {
  final userID = FirebaseAuth.instance.currentUser?.uid;

  final categoryCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .collection('Categories');

  final Stream<QuerySnapshot> categoryStream = categoryCollection.snapshots();

  await for (final categorySnapshot in categoryStream) {
    final categoriesSnapshot = await categoryCollection.get();
    var categories = <UserCreatedCategoryModel>[];
    categories.addAll(categoriesSnapshot.docs.map((categoryDoc) {
      final categoryData = categoryDoc.data();
      return UserCreatedCategoryModel(
          categoryID: categoryDoc.id,
          categoryName: categoryData['categoryName'] ?? '',
          colorHex: categoryData['colorHex'] ?? '');
    }));
    ref.read(categoryProvider.notifier).updateCategoriesState(categories);

    var tasks = <TaskModel>[];

    for (final categoryDoc in categorySnapshot.docs) {
      final tasksCollection = categoryDoc.reference.collection('Tasks');
      final tasksSnapshot = await tasksCollection.get();

      tasks.addAll(
        tasksSnapshot.docs.map((taskDoc) {
          final taskData = taskDoc.data();
          return TaskModel(
            docID: taskDoc.id,
            taskTitle: taskData['taskTitle'] ?? '',
            description: taskData['description'] ?? '',
            categoryID: taskData['categoryID'] ?? '',
            categoryName: taskData['categoryName'] ?? '',
            categoryColorHex: taskData['categoryColorHex'] ?? '',
            dateTask: taskData['dateTask'] ?? '',
            timeTask: taskData['timeTask'] ?? '',
            isDone: taskData['isDone'] ?? false,
          );
        }),
      );
    }

    tasks.sort((a, b) => a.dateTask.compareTo(b.dateTask));

    ref.read(taskListProvider.notifier).updateTasks(tasks);
    yield tasks;
  }
});
