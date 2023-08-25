import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'category.model.dart';

final categoryServiceProvider = StateProvider<CategoryService>(
  (ref) {
    return CategoryService();
  },
);

//////CategoryService begin

class CategoryService {
  final users = FirebaseFirestore.instance.collection('users');
  final userID = FirebaseAuth.instance.currentUser?.uid;

  Future<DocumentReference> addNewCategory(
      UserCreatedCategoryModel model) async {
    return users.doc(userID).collection('Categories').add(model.toJson());
  }

  Future<void> updateCategory(BuildContext context, WidgetRef ref,
      UserCreatedCategoryModel model) async {
    try {
      final categoryReference =
          users.doc(userID).collection('Categories').doc(model.categoryID);

      await categoryReference.update(model.toJson());
    } catch (e) {
      return;
    }
  }

  Future<void> deleteCategory(String userID, String categoryID) async {
    CollectionReference categoriesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Categories');

    await categoriesCollection.doc(categoryID).delete();
  }

  Future<bool> checkCategoryExists(String categoryName) async {
    String userID = FirebaseAuth.instance.currentUser?.uid ?? '';
    final categorySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Categories')
        .where('categoryName', isEqualTo: categoryName)
        .get();

    return categorySnapshot.docs.isNotEmpty;
  }

  Future<void> categoryEmptyAlertMethod(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text(
                'Category Name cannot be empty',
              ),
              backgroundColor: Colors.white,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                )
              ]);
        });
  }

  Future<void> categoryNameInUseMessage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text(
                'Category Name is already in use',
              ),
              backgroundColor: Colors.white,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                )
              ]);
        });
  }
}
