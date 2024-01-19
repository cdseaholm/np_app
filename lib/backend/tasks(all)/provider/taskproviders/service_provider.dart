import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:np_app/backend/tasks(all)/widgets/category_widget_all/category.model.dart';

import '../../taskmodels/task_model.dart';
import '../../widgets/category_widget_all/category_provider.dart';
import 'task_providers.dart';

//state providers

final dateProvider = StateProvider<String>((ref) {
  return 'mm/dd/yy';
});

final timeProvider = StateProvider<String>((ref) {
  return 'hh:mm';
});

final repeatingOptionDays = StateProvider<List<String>>((ref) {
  return [];
});

final repeatingOptionFrequency = StateProvider<String>((ref) {
  return 'No';
});

final stopDateProvider = StateProvider<String>((ref) {
  return 'Until?';
});

final repeatShownProvider = StateProvider<String>((ref) {
  return 'No';
});

//Category/Tasks fetching

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
              docID: taskData['docID'] ?? '',
              taskTitle: taskData['taskTitle'] ?? '',
              description: taskData['description'] ?? '',
              categoryID: taskData['categoryID'] ?? '',
              categoryName: taskData['categoryName'] ?? '',
              categoryColorHex: taskData['categoryColorHex'] ?? '',
              dateTask: taskData['dateTask'] ?? '',
              timeTask: taskData['timeTask'] ?? '',
              isDone: taskData['isDone'] ?? false,
              status: taskData['status'] ?? '',
              repeatShown: taskData['repeatShown'] ?? '',
              repeatingDays: taskData[['repeating']] ?? [],
              repeatingFrequency: taskData['repeatingFrequency'] ?? '',
              creationDate: taskData['creationDate'] ?? '',
              stopDate: taskData['stopDate'] ?? '');
        }),
      );
    }

    yield tasks;

    ref.read(taskListProvider.notifier).updateTasks(tasks);
  }
});

//update task

final updateTaskProvider = Provider((ref) => UpdateTaskService());

class UpdateTaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<TaskModel?> updateTaskFields({
    required String userID,
    required String categoryID,
    required String categoryName,
    required String taskID,
    String? newStatus,
    String? newTitle,
    String? newDescription,
    String? newTime,
    String? newDate,
    List<String?>? newRepeatDays,
    String? newRepeatFrequency,
    String? newRepeatShown,
    String? newRepeatUntil,
    // Add other fields here as needed
  }) async {
    final taskRef = _firestore
        .collection('users')
        .doc(userID)
        .collection('Categories')
        .doc(categoryID)
        .collection('Tasks')
        .doc(taskID);

    final Map<String, dynamic> updatedFields = {};

    if (newTitle != null) {
      updatedFields['taskTitle'] = newTitle;
    }

    if (newDescription != null) {
      updatedFields['description'] = newDescription;
    }

    if (newTime != null) {
      updatedFields['timeTask'] = newTime;
    }

    if (newDate != null) {
      updatedFields['dateTask'] = newDate;
    }

    if (newRepeatDays != null) {
      updatedFields['repeatingDays'] = newRepeatDays;
    }

    if (newRepeatFrequency != null) {
      updatedFields['repeatingFrequency'] = newRepeatFrequency;
    }

    if (newRepeatShown != null) {
      updatedFields['repeatShown'] = newRepeatShown;
    }

    if (newRepeatUntil != null) {
      updatedFields['stopDate'] = newRepeatUntil;
    }

    await taskRef.update(updatedFields);
    final DocumentSnapshot updatedDoc = await taskRef.get();
    final updatedTaskData = updatedDoc.data() as Map<String, dynamic>;
    final updatedTask = TaskModel.fromJson(updatedTaskData);

    return updatedTask;
  }
}
