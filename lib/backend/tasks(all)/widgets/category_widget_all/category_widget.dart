import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../provider/taskproviders/selected_category_providers.dart';
import '../constants/constants.dart';

import 'category.model.dart';
import 'category_edit.dart';
import 'category_provider.dart';
import 'category_service.dart';

class CategoryWidget extends ConsumerStatefulWidget {
  const CategoryWidget({
    Key? key,
    required this.selectedCategoryColor,
    required this.selectedCategoryName,
  }) : super(key: key);

  final String selectedCategoryColor;
  final String selectedCategoryName;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends ConsumerState<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    final selectedCategoryColor = ref.watch(selectedCategoryProvider).colorHex;
    final selectedCategoryName =
        ref.watch(selectedCategoryProvider).categoryName;
    var shownCategory = 'Select Category';
    if (selectedCategoryName == 'No Category') {
      setState(() {
        shownCategory = 'Select Category';
      });
    }
    if (selectedCategoryName != 'No Category') {
      setState(() {
        shownCategory = selectedCategoryName;
      });
    }

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
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const SelectCategoryMethod();
                      });
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
                      if (shownCategory != 'Select Category')
                        CircleAvatar(
                          backgroundColor: colorFromHex(selectedCategoryColor),
                          radius: 8,
                        ),
                      const Gap(6),
                      Text(shownCategory),
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
    return AlertDialog(
      scrollable: true,
      title: const Text('Select Category'),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (categories.isEmpty) const Text(''),
          if (categories.isNotEmpty) const CategoryList(),
          TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Custom Category'),
            onPressed: () {
              showAddCategoryDialog(context, ref);
            },
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (categories.isNotEmpty)
              TextButton(
                onPressed: () async {
                  Edit().editCategoryDialog(context, ref);
                },
                child: const Text('Edit Categories'),
              ),
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
            ref
                .read(selectedCategoryProvider.notifier)
                .update((state) => UserCreatedCategoryModel(
                      categoryID: category.categoryID,
                      categoryName: category.categoryName,
                      colorHex: category.colorHex,
                    ));
            Navigator.of(context).pop(true);
          },
        );
      }).toList(),
    );
  }
}

Future<void> showAddCategoryDialog(BuildContext context, WidgetRef ref) async {
  final colorController = TextEditingController();
  final categoryNameController = TextEditingController();
  late var pickerColor = const Color(0xFF4C7755);
  late String categoryID = ref.watch(selectedCategoryProvider).categoryID;

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
                  if (categoryNameController.text.isEmpty) {
                    return CategoryService().categoryEmptyAlertMethod(context);
                  }
                  final catModel = await addCategory(
                    context,
                    ref,
                    colorController.text,
                    categoryNameController.text,
                  );
                  if (catModel != null) {
                    ref
                        .read(selectedCategoryProvider.notifier)
                        .update((state) => UserCreatedCategoryModel(
                              categoryID: categoryID,
                              categoryName: catModel.categoryName,
                              colorHex: catModel.colorHex,
                            ));
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

Future<UserCreatedCategoryModel?> addCategory(BuildContext context,
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
        // ignore: use_build_context_synchronously
        CategoryService().categoryNameInUseMessage(context);
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
    } else {
      CategoryService().categoryEmptyAlertMethod(context);
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    return userCreatedCategoryModel;
  } catch (e) {
    // ignore: avoid_print
    print("Exception in addCategory: $e");
    return null;
  }
}
