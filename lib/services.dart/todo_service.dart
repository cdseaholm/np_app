import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:np_app/backend/models/todo_model.dart';

class ToDoService {
  final todoCollection = FirebaseFirestore.instance.collection('todoApp');

  // CRUD

  // CREATE
  void addNewTask(ToDoModel model) {
    todoCollection.add(model.toMap());
  }
}
