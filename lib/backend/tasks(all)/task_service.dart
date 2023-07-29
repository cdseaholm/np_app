import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:np_app/backend/models/todo_model.dart';

class ToDoService {
  final users = FirebaseFirestore.instance.collection('users');

  // CRUD

  // CREATE
  void addNewTask(ToDoModel model, String userID) {
    if (model.docID.isEmpty) {
      // If docID is not provided or is an empty string, generate a new ID
      final newDocRef = users.doc(userID).collection('tasks').doc();
      model.docID = newDocRef.id;
    }

    users.doc(userID).collection('tasks').doc(model.docID).set(model.toMap());
  }

  // UPDATE
  void updateTask(String userID, String docID, bool? valueUpdate) {
    users
        .doc(userID)
        .collection('tasks')
        .doc(docID)
        .update({'isDone': valueUpdate});
  }

  // DELETE
  void deleteTask(String userID, String docID) {
    users.doc(userID).collection('tasks').doc(docID).delete();
  }
}
