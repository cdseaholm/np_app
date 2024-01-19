import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../provider/taskproviders/selected_category_providers.dart';
import 'category.model.dart';
import 'category_provider.dart';

//////CategoryService begin

class CategoryService {
  final users = FirebaseFirestore.instance.collection('users');
  final userID = FirebaseAuth.instance.currentUser?.uid;

  Future<DocumentReference> addNewCategory(
      WidgetRef ref, UserCreatedCategoryModel model) async {
    final addedCategoryReference =
        await users.doc(userID).collection('Categories').add(model.toJson());

    final categoryIDMake = addedCategoryReference.id;

    ref.read(categoryServiceProvider).updateCategory(
          ref,
          UserCreatedCategoryModel(
            categoryID: categoryIDMake,
            categoryName: model.categoryName,
            colorHex: model.colorHex,
          ),
        );

    return addedCategoryReference;
  }

  Future<void> updateCategory(
    WidgetRef ref,
    UserCreatedCategoryModel model,
  ) async {
    try {
      final categoryReference =
          users.doc(userID).collection('Categories').doc(model.categoryID);

      await categoryReference.update(model.toJson());

      ref.read(selectedCategoryProvider.notifier).state = model;
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

  Future<String> getNoCategoryID(String categoryName) async {
    String userID = FirebaseAuth.instance.currentUser?.uid ?? '';
    final QuerySnapshot categorySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Categories')
        .where('categoryName', isEqualTo: categoryName)
        .get();

    return categorySnapshot.docs.first.id;
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
                  child: const Text('Back'),
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

Future<UserCreatedCategoryModel?> addNoCategory(BuildContext context,
    WidgetRef ref, String colorHex, String categoryName) async {
  final userCreatedCategoryModel = UserCreatedCategoryModel(
    categoryName: categoryName,
    colorHex: colorHex,
  );

  try {
    if (categoryName.isNotEmpty) {
      final categoryExists =
          await CategoryService().checkCategoryExists(categoryName);

      if (categoryExists) {
        final noCategoryID =
            await CategoryService().getNoCategoryID('No Category');

        ref.read(selectedCategoryProvider.notifier).state =
            UserCreatedCategoryModel(
          categoryID: noCategoryID,
          categoryName: userCreatedCategoryModel.categoryName,
          colorHex: userCreatedCategoryModel.colorHex,
        );
      } else {
        final categoryService = ref.read(categoryServiceProvider);

        final addedCategoryReference =
            await categoryService.addNewCategory(ref, userCreatedCategoryModel);

        final categoryIDMake = addedCategoryReference.id;

        ref.read(selectedCategoryProvider.notifier).state =
            UserCreatedCategoryModel(
          categoryID: categoryIDMake,
          categoryName: userCreatedCategoryModel.categoryName,
          colorHex: userCreatedCategoryModel.colorHex,
        );

        return userCreatedCategoryModel;
      }
    }

    return userCreatedCategoryModel;
  } catch (e) {
    // ignore: avoid_print
    print("Exception in addCategory: $e");
    return null;
  }
}
