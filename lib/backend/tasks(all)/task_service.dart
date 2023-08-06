import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:np_app/backend/tasks(all)/taskmodels/todo_model.dart';

class ToDoService {
  final users = FirebaseFirestore.instance.collection('users');

  // CRUD

  // CREATE
  void addNewTask(ToDoModel model, String userID, String category) {
    if (model.docID.isEmpty) {
      // If docID is not provided or is an empty string, generate a new ID
      final newTaskRef = users.doc(userID).collection('$category Tasks').doc();
      model.docID = newTaskRef.id;
    }

    users
        .doc(userID)
        .collection('$category Tasks')
        .doc(model.docID)
        .set(model.toMap());
  }

  // UPDATE
  void updateTask(
      String userID, String docID, String category, bool? valueUpdate) {
    users
        .doc(userID)
        .collection('$category Tasks')
        .doc(docID)
        .update({'isDone': valueUpdate});
  }

  // DELETE
  void deleteTask(String userID, String docID, String category) {
    users.doc(userID).collection('$category Tasks').doc(docID).delete();
  }
}
