import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_app/backend/tasks(all)/provider/taskproviders/service_provider.dart';
import '../../provider/taskproviders/selected_category_providers.dart';
import '../constants/constants.dart';

import 'category.model.dart';
import 'category_edit.dart';
import 'category_service.dart';

class CategoryWidget extends ConsumerWidget {
  const CategoryWidget({
    Key? key,
    required this.selectedCategoryColor,
    required this.selectedCategoryName,
  }) : super(key: key);

  final String selectedCategoryColor;
  final String selectedCategoryName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategoryColor = ref.watch(categoryNameRadioProvider).colorHex;
    final selectedCategoryName =
        ref.watch(categoryNameRadioProvider).categoryName;

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
                  selectCategoryMethod(context, ref);
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
}

class SelectCategoryMethod extends ConsumerStatefulWidget {
  const SelectCategoryMethod({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectCategoryMethodState();
}

class _SelectCategoryMethodState extends ConsumerState<SelectCategoryMethod> {
  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);

    return Column(
      children: categories.asMap().entries.map((entry) {
        final category = entry.value;
        return ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: colorFromHex(category.colorHex),
                radius: 12,
              ),
              const SizedBox(width: 8),
              Text(
                category.categoryName,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          onTap: () async {
            ref.read(categoryNameRadioProvider.notifier).state =
                UserCreatedCategoryModel(
              categoryID: category.categoryID,
              categoryName: category.categoryName,
              colorHex: category.colorHex,
            );
            Navigator.of(context).pop(true);
          },
        );
      }).toList(),
    );
  }
}

class CategoryList extends ConsumerWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);

    return Column(
      children: categories.asMap().entries.map((entry) {
        final category = entry.value;
        return ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: colorFromHex(category.colorHex),
                radius: 12,
              ),
              const SizedBox(width: 8),
              Text(
                category.categoryName,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          onTap: () async {
            ref.read(categoryNameRadioProvider.notifier).state =
                UserCreatedCategoryModel(
              categoryID: category.categoryID,
              categoryName: category.categoryName,
              colorHex: category.colorHex,
            );
            Navigator.of(context).pop(true);
          },
        );
      }).toList(),
    );
  }
}

Future<void> selectCategoryMethod(
  BuildContext context,
  WidgetRef ref,
) async {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Select Category'),
          backgroundColor: Colors.white,
          content: StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SelectCategoryMethod(),
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Custom Category'),
                  onPressed: () {
                    showAddCategoryDialog(context, ref);
                  },
                )
              ],
            );
          }),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () async {
                      Edit().editCategoryDialog(context, ref);
                    },
                    child: const Text('Edit Categories')),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
          ],
        );
      });
}

Future<void> showAddCategoryDialog(BuildContext context, WidgetRef ref) async {
  final colorController = TextEditingController();
  final categoryNameController = TextEditingController();
  late var pickerColor = const Color(0xFF4C7755);
  late String categoryID = ref.watch(categoryNameRadioProvider).categoryID;

  return showDialog(
    context: context,
    builder: (dialogContext) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  final scaffoldState = ScaffoldMessenger.of(dialogContext);
                  scaffoldState.showSnackBar(
                    const SnackBar(content: Text('Adding category...')),
                  );
                  final catModel = await addCategory(
                    context,
                    ref,
                    categoryID,
                    colorController.text,
                    categoryNameController.text,
                  );
                  if (catModel != null) {
                    ref.read(categoryNameRadioProvider.notifier).state =
                        UserCreatedCategoryModel(
                      categoryID: categoryID,
                      categoryName: catModel.categoryName,
                      colorHex: catModel.colorHex,
                    );
                  }
                  if (context.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Future<UserCreatedCategoryModel?> addCategory(
    BuildContext context,
    WidgetRef ref,
    String categoryID,
    String colorHex,
    String categoryName) async {
  final userCreatedCategoryModel = UserCreatedCategoryModel(
    categoryID: categoryID,
    categoryName: categoryName,
    colorHex: colorHex,
  );

  try {
    if (categoryName.isNotEmpty) {
      final categoryExists =
          await CategoryService().checkCategoryExists(categoryName);

      if (categoryExists) {
        // ignore: use_build_context_synchronously
        CategoryService().categoryNameInUseMessage(context);
      } else {
        final addedCategoryReference = await ref
            .read(categoryServiceProvider)
            .addNewCategory(userCreatedCategoryModel);

        final categoryIDMake = addedCategoryReference.id;

        ref.read(categoryNameRadioProvider.notifier).state =
            UserCreatedCategoryModel(
          categoryID: categoryIDMake,
          categoryName: userCreatedCategoryModel.categoryName,
          colorHex: userCreatedCategoryModel.colorHex,
        );

        return userCreatedCategoryModel;
      }
    } else {
      CategoryService().categoryEmptyAlertMethod(context);
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
