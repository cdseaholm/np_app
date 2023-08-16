import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_app/backend/tasks(all)/task_service.dart';
import 'package:np_app/backend/tasks(all)/widgets/category_widget_all/category.model.dart';

import '../../taskmodels/task_model.dart';

final serviceProvider = StateProvider<ToDoService>((ref) {
  return ToDoService();
});

Stream<List<TaskModel?>> loadTaskData() async* {
  final userID = FirebaseAuth.instance.currentUser?.uid;
  final catModel =
      UserCreatedCategoryModel(categoryID: '', categoryName: '', colorHex: '');
  final categoryID = catModel.categoryID;
  try {
    final QuerySnapshot<Map<String, dynamic>> tasksQuery =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .collection('Categories')
            .doc(categoryID)
            .collection('Tasks')
            .get();
    final tasks =
        tasksQuery.docs.map((task) => TaskModel.fromSnapshot(task)).toList();
    // ignore: avoid_print
    print("...Tasks...${tasks[0]}");
    yield tasks;
  } catch (e) {
    // Handle the error
    yield [];
  }
}

/*
final fetchDataProvider =
    StreamProvider.autoDispose<List<TaskModel>>((ref) async* {
  final categoryModel = ref.watch(categoryModelProvider);
  final categoryID = categoryModel.categoryID;
  final userID = ref.watch(authStateProvider).maybeWhen(
        data: (user) => user?.uid,
        orElse: () => null,
      );

  if (userID != null) {
    final tasksCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Categories')
        .doc(categoryID)
        .collection('Tasks')
        .snapshots()
        .map((event) => event.docs
            .map((snapshot) => TaskModel.fromSnapshot(snapshot))
            .toList());

    tasksCollection.listen((tasks) {
      if (kDebugMode) {
        print('Categories: $tasks');
      }
      if (kDebugMode) {
        print("categoryID: $categoryID");
      }
    });
    yield* tasksCollection;
  } else {
    yield [];
  }
});
*/
