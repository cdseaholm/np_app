import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'constants/constants.dart';

class Category {
  final Color color;
  final String name;
  final String value;

  Category({
    required this.color,
    required this.name,
    required this.value,
  });
}

class CategoryWidget extends ConsumerStatefulWidget {
  const CategoryWidget({
    Key? key,
    required this.categories,
    required this.onCategorySelected,
    required this.selectedCategory,
    required this.selectedColor,
  }) : super(key: key);

  final List<Category> categories;
  final Function(String, Color) onCategorySelected;
  final String selectedCategory;
  final Color selectedColor;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends ConsumerState<CategoryWidget> {
  String selectedCategory = 'Select Category';
  Color selectedColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
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
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        scrollable: true,
                        title: const Text('Select Category'),
                        backgroundColor: Colors.white,
                        content: SingleChildScrollView(
                          child: Column(
                            children: widget.categories.map((category) {
                              final isSelected =
                                  category.name == widget.selectedCategory;

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: category.color,
                                  radius: 12,
                                ),
                                title: Row(
                                  children: [
                                    if (isSelected)
                                      CircleAvatar(
                                        backgroundColor: category.color,
                                        radius: 6,
                                      ),
                                    const Gap(6),
                                    Text(
                                      category.name,
                                      style: TextStyle(
                                        color: category.color,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    widget.onCategorySelected(
                                        category.name, category.color);
                                  });
                                  Navigator.of(context).pop();
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
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
                      Text(widget.selectedCategory),
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


/*
class CategoryWidget extends ConsumerWidget {
  const CategoryWidget({
    Key? key,
    required this.titleText,
    required this.iconSection,
    required this.onTap,
  }) : super(key: key);

  final String titleText;
  final IconData iconSection;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleText,
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
                onTap: onTap,
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
                      Icon(iconSection),
                      const Gap(6),
                      Text(ref
                          .watch(categoryProvider)
                          .toString()), // Display the selected category
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
class CategoryDialog extends StatelessWidget {
  final List<String> categoryOptions;
  final Function(String) onCategorySelected;

  const CategoryDialog({
    super.key,
    required this.categoryOptions,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: categoryOptions.map((category) {
          return ListTile(
            title: Text(category),
            onTap: () {
              Navigator.of(context).pop();
              onCategorySelected(category);
            },
          );
        }).toList(),
      ),
    );
  }
}
class CategoryDropdown extends StatelessWidget {
  final List<Category> dropdownMenuEntries;
  final Function(String) onCategorySelected;

  const CategoryDropdown({
    super.key,
    required this.dropdownMenuEntries,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      items: dropdownMenuEntries.map((category) {
        return DropdownMenuItem<String>(
          value: category.name,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: category.color,
              radius: 12,
            ),
            title: Transform.translate(
              offset: const Offset(-22, 0),
              child: Text(
                category.name,
                style: TextStyle(
                  color: category.color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        );
      }).toList(),
      onChanged: (selectedCategory) {
        onCategorySelected(selectedCategory!);
      },
      underline: const SizedBox(),
      isExpanded: true,
      hint: const SizedBox.shrink(),
    );
  }
}
*/
