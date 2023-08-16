import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../provider/taskproviders/task_providers.dart';
import '../../taskmodels/task_model.dart';
import '../constants/constants.dart';

import 'category.model.dart';
import 'category_provider.dart';

class CategoryWidget extends ConsumerWidget {
  const CategoryWidget({
    Key? key,
    required this.selectedCategoryColor,
    required this.selectedCategoryName,
  }) : super(key: key);

  final String selectedCategoryColor;
  final String selectedCategoryName;

  void openCategoryDialog(BuildContext context, WidgetRef ref) async {
    final categories = await loadCategoryData().first;
    // ignore: use_build_context_synchronously
    selectCategoryMethod(context, categories, ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategoryColor = ref.watch(categoryColorRadioProvider);
    final selectedCategoryName = ref.watch(categoryNameRadioProvider);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category',
            style: AppStyle.headingTwo,
          ),
          const Gap(6),
          Material(
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: .5),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  openCategoryDialog(context, ref);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.add),
                      const Gap(6),
                      if (selectedCategoryName != 'Select Category')
                        CircleAvatar(
                          backgroundColor: colorFromHex(selectedCategoryColor),
                          radius: 8,
                        ),
                      const Gap(6),
                      Text(selectedCategoryName),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> selectCategoryMethod(BuildContext mainContext,
      List<UserCreatedCategoryModel?> categories, WidgetRef ref) async {
    return showDialog(
        context: mainContext,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Select Category'),
            backgroundColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                existingCategoryMethod(context, categories, ref),
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Custom Category'),
                  onPressed: () {
                    showAddCategoryDialog(context, ref);
                  },
                )
              ],
            ),
            actions: [
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  Widget existingCategoryMethod(BuildContext mainContext,
      List<UserCreatedCategoryModel?> categories, WidgetRef ref) {
    if (categories.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: categories.map((category) {
        return ListTile(
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: colorFromHex(category!.colorHex),
                radius: 12,
              ),
              const SizedBox(width: 8),
              Text(
                category.categoryName,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          onTap: () {
            ref
                .read(categoryColorRadioProvider.notifier)
                .update((state) => category.colorHex);
            ref
                .read(categoryNameRadioProvider.notifier)
                .update((state) => category.categoryName);

            Navigator.of(mainContext).pop();
          },
        );
      }).toList(),
    );
  }

  Future<void> showAddCategoryDialog(
      BuildContext context, WidgetRef ref) async {
    final colorController = TextEditingController();
    final categoryNameController = TextEditingController();
    late var pickerColor = const Color(0xFF4C7755);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Category Color and Name'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 16),
                    ColorPicker(
                      pickerAreaHeightPercent: .5,
                      pickerColor: pickerColor,
                      enableAlpha: false,
                      labelTypes: List.empty(),
                      hexInputController: colorController,
                      onColorChanged: (color) {
                        setState(() {
                          pickerColor = color;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: categoryNameController,
                      decoration: const InputDecoration(
                        labelText: 'Category Name',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final newCategory = await addCategory(
                  context,
                  ref,
                  colorController.text,
                  categoryNameController.text,
                );
                if (newCategory != null) {
                  ref
                      .read(categoryServiceProvider)
                      .addNewCategory(newCategory, newCategory.categoryID);
                  ref.read(categoryColorRadioProvider.notifier).update((state) {
                    return newCategory.colorHex;
                  });
                  ref.read(categoryNameRadioProvider.notifier).update((state) {
                    return newCategory.categoryName;
                  });
                }
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<UserCreatedCategoryModel?> addCategory(BuildContext context,
      WidgetRef ref, String colorHex, String categoryName) async {
    final categoryID = 'Category: $categoryName';
    final userCreatedCategoryModel = UserCreatedCategoryModel(
      categoryID: categoryID,
      categoryName: categoryName,
      colorHex: colorHex,
    );

    try {
      if (categoryName.isNotEmpty) {
        final categoryExists = await checkCategoryExists(categoryName);

        if (categoryExists) {
          // ignore: use_build_context_synchronously
          categoryNameInUseMessage(context);
        } else {
          ref
              .watch(categoryServiceProvider)
              .addNewCategory(userCreatedCategoryModel, categoryID);

          ref.read(categoryColorRadioProvider.notifier).update((state) {
            return colorHex;
          });

          ref.read(categoryNameRadioProvider.notifier).update((state) {
            return categoryName;
          });

          return userCreatedCategoryModel;
        }
      } else {
        categoryEmptyAlertMethod(context);
      }
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();

      return userCreatedCategoryModel;
    } catch (e) {
      // ignore: avoid_print
      print("Exception in addCategory: $e");
      return null;
    }
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

  Future<void> deleteCategoryMethod(
      BuildContext context,
      UserCreatedCategoryModel categoryModel,
      TaskModel toDoModel,
      WidgetRef ref) async {
    final userID = FirebaseAuth.instance.currentUser?.uid;

    final categoryID = categoryModel.categoryID;
    final taskTitle = toDoModel.taskTitle;
    final taskID = toDoModel.docID;

    if (kDebugMode) {
      print("userID: $userID");
    }
    if (kDebugMode) {
      print("categoryID: $categoryID");
    }
    if (kDebugMode) {
      print("taskID: $taskID");
    }
    if (kDebugMode) {
      print("taskTitle: $taskTitle");
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Deleting Category, will delete all Tasks in this Category, do you want to Continue?',
          ),
          backgroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }
}
