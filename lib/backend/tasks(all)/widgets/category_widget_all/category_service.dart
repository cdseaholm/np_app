import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'category.model.dart';

class CategoryService {
  final users = FirebaseFirestore.instance.collection('users');
  final userID = FirebaseAuth.instance.currentUser?.uid;

  Future<void> addNewCategory(
      UserCreatedCategoryModel model, String categoryID) async {
    users
        .doc(userID)
        .collection('Categories')
        .doc(categoryID)
        .set(model.toJson());
  }

  Future<void> deleteCategory(String userID, String categoryID) async {
    CollectionReference categoriesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Categories');

    await categoriesCollection.doc(categoryID).delete();
  }
}
