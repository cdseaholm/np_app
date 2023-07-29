import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_app/backend/auth_pages/auth_provider.dart';
import 'package:np_app/backend/models/todo_model.dart';
import 'package:np_app/backend/tasks(all)/task_service.dart';

final serviceProvider = StateProvider<ToDoService>((ref) {
  return ToDoService();
});

final fetchDataProvider = StreamProvider<List<ToDoModel>>((ref) async* {
  final userID = ref.watch(authStateProvider).maybeWhen(
        data: (user) => user?.uid,
        orElse: () => null,
      );
  if (userID != null) {
    final getData = FirebaseFirestore.instance
        .collection('users')
        .doc(userID) // Filter tasks based on the user's ID
        .collection('tasks')
        .snapshots()
        .map((event) => event.docs
            .map((snapshot) => ToDoModel.fromSnapshot(snapshot))
            .toList());
    if (kDebugMode) {
      print('snapshots');
    }

    getData.listen((tasks) {
      // ignore: avoid_print
      print('Tasks: $tasks');
    });
    yield* getData;
  } else {
    yield [];
  }
});
