import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:np_app/backend/models/todo_model.dart';

class ToDoService {
  final users = FirebaseFirestore.instance.collection('users');

  // CRUD

  // CREATE
  void addNewTask(ToDoModel model, String userId) {
    users.doc(userId).collection('tasks').add(model.toMap());
  }
}
