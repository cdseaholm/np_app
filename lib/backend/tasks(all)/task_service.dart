import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:np_app/backend/tasks(all)/taskmodels/task_model.dart';

final serviceProvider = StateProvider<ToDoService>((ref) {
  return ToDoService();
});

class ToDoService {
  final users = FirebaseFirestore.instance.collection('users');

  // CRUD

  // CREATE

  void addNewTask(TaskModel model, String userID, String categoryID) {
    users
        .doc(userID)
        .collection('Categories')
        .doc(categoryID)
        .collection('Tasks')
        .add(model.toJson());
  }

  // UPDATE
  void updateTask(
      String userID, String categoryID, String taskID, bool? valueUpdate) {
    users
        .doc(userID)
        .collection('Categories')
        .doc(categoryID)
        .collection('Tasks')
        .doc(taskID)
        .update({'isDone': valueUpdate});
  }

  // DELETE
  Future<void> deleteTask(
      String userID, String categoryID, String taskID) async {
    DocumentReference<Map<String, dynamic>> tasksToDelete = FirebaseFirestore
        .instance
        .collection('users')
        .doc(userID)
        .collection('Categories')
        .doc(categoryID)
        .collection('Tasks')
        .doc(taskID);

    await tasksToDelete.delete();
  }
}
