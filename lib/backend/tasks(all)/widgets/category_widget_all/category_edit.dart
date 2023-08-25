import 'package:np_app/backend/tasks(all)/provider/taskproviders/service_provider.dart';

import '../../provider/taskproviders/selected_category_providers.dart';
import 'category.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'category_service.dart';

class EditCategoryDialogContent extends ConsumerStatefulWidget {
  const EditCategoryDialogContent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCategoryDialogContentState();
}

class _EditCategoryDialogContentState
    extends ConsumerState<EditCategoryDialogContent> {
  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);

    return Column(
      children: categories.asMap().entries.map((entry) {
        final category = entry.value;
        return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  CircleAvatar(
                    backgroundColor: colorFromHex(category.colorHex),
                    radius: 12,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category.categoryName,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ]),
                Row(children: [
                  TextButton(
                      onPressed: () {
                        ref.read(categoryUpdateRadioProvider.notifier).state =
                            UserCreatedCategoryModel(
                          categoryID: category.categoryID,
                          categoryName: category.categoryName,
                          colorHex: category.colorHex,
                        );
                        editThisCategory(context, ref);
                      },
                      child: const Text('Edit')),
                  IconButton(
                      onPressed: () {
                        deleteCategoryMethod(context, ref);
                      },
                      icon: const Icon(CupertinoIcons.trash))
                ]),
              ],
            ),
            onTap: () async {
              bool? yes = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => const EditCategoryDialogContent(),
              );
              if (context.mounted) {
                if (yes == true) {
                  Navigator.pushReplacementNamed(context, 'editCategory1');
                } else {
                  Navigator.pop(context);
                }
              }
            });
      }).toList(),
    );
  }
}

class Edit {
  Future<void> editCategoryDialog(BuildContext context, WidgetRef ref) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Edit Categories'),
            backgroundColor: Colors.white,
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                EditCategoryDialogContent(),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      ref.read(categoryProvider);

                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Done'),
                  ),
                ],
              ),
            ],
          );
        });
  }
}

Future<void> editThisCategory(BuildContext context, WidgetRef ref) async {
  final colorController = TextEditingController();
  final categoryNameController = TextEditingController();
  final selectedCategory = ref.watch(categoryUpdateRadioProvider);

  categoryNameController.text = selectedCategory.categoryName;
  colorController.text = selectedCategory.colorHex;
  var pickerColor = colorFromHex(selectedCategory.colorHex);

  return showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Edit Category Color and Name'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 16),
                  ColorPicker(
                    pickerAreaHeightPercent: .5,
                    pickerColor: pickerColor!,
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
          ElevatedButton(
            onPressed: () async {
              final scaffoldState = ScaffoldMessenger.of(dialogContext);
              scaffoldState.showSnackBar(
                const SnackBar(content: Text('Updating category...')),
              );
              final updatedCategoryModel = UserCreatedCategoryModel(
                categoryID: selectedCategory.categoryID,
                categoryName: categoryNameController.text,
                colorHex: colorController.text,
              );

              ref.read(categoryUpdateRadioProvider.notifier).state =
                  updatedCategoryModel;

              await CategoryService()
                  .updateCategory(context, ref, updatedCategoryModel);

              if (context.mounted) {
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('Done'),
          ),
        ],
      );
    },
  );
}

Future<void> deleteCategoryMethod(BuildContext context, WidgetRef ref) async {
  final userID = FirebaseAuth.instance.currentUser?.uid;
  final categoryID = ref.watch(categoryNameRadioProvider).categoryID;

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
              await CategoryService().deleteCategory(userID!, categoryID);
              if (context.mounted) {
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('Continue'),
          ),
        ],
      );
    },
  );
}
