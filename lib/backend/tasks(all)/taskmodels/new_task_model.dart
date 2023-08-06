import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:np_app/backend/tasks(all)/widgets/constants/constants.dart';
import 'package:np_app/backend/tasks(all)/taskmodels/todo_model.dart';
import 'package:np_app/backend/tasks(all)/widgets/task_widgets.dart';
import 'package:np_app/backend/tasks(all)/provider/taskproviders/task_providers.dart';
import 'package:np_app/backend/tasks(all)/provider/taskproviders/service_provider.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import '../widgets/category_widget.dart';
import '../widgets/textfield_widget.dart';

class AddNewTaskModel extends ConsumerStatefulWidget {
  const AddNewTaskModel({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddNewTaskModelState();
}

class _AddNewTaskModelState extends ConsumerState<AddNewTaskModel> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String selectedCategory = 'Select Category';
  late final Function(String) onCategorySelected;
  List<Category> categories = [
    Category(color: Colors.green, name: 'LRN', value: ''),
    Category(color: Colors.blue.shade700, name: 'WRK', value: ''),
    Category(color: Colors.amberAccent.shade700, name: 'GEN', value: ''),
  ];
  Color selectedColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    titleController.text = '';
    descriptionController.text = '';
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void updateCategory(String category, Color color) {
    setState(() {
      selectedCategory = category;
      selectedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateProv = ref.watch(dateProvider);
    final uID = FirebaseAuth.instance.currentUser?.uid;

    if (uID == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: HexColor("#456B4C"),
              title: const Center(
                child: Text(
                  'Sign in to add new Tasks',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Back',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]);
        },
      );
    }

    return Container(
        padding: const EdgeInsets.all(30),
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            width: double.infinity,
            child: Text(
              'New Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          Divider(
            thickness: 1.2,
            color: Colors.grey.shade200,
          ),
          const Gap(12),
          const Text(
            'Task Title',
            style: AppStyle.headingOne,
          ),
          const Gap(6),
          TextFieldWidget(
            maxLine: 1,
            hintText: 'Add Task Name',
            txtController: titleController,
          ),
          const Gap(12),
          const Text('Description', style: AppStyle.headingOne),
          const Gap(6),
          TextFieldWidget(
            maxLine: 3,
            hintText: 'Add Descriptions',
            txtController: descriptionController,
          ),
          const Gap(12),

          const Divider(
            thickness: 1,
            color: Colors.black,
          ),

          // Date and Time Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DateTimeWidget(
                titleText: 'Date',
                valueText: dateProv,
                iconSection: CupertinoIcons.calendar,
                onTap: () async {
                  final getValue = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2021),
                      lastDate: DateTime(2025));

                  if (getValue != null) {
                    final format = DateFormat.yMMMEd();
                    ref
                        .read(dateProvider.notifier)
                        .update((state) => format.format(getValue));
                  }
                },
              ),
              const Gap(22),
              DateTimeWidget(
                titleText: 'Time',
                valueText: ref.watch(timeProvider),
                iconSection: CupertinoIcons.clock,
                onTap: () async {
                  final getTime = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());

                  if (getTime != null) {
                    ref
                        .read(timeProvider.notifier)
                        .update((state) => getTime.format(context));
                  }
                },
              ),
            ],
          ),
          const Gap(12),

          //Category, Repeat

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CategoryWidget(
              // Pass the callback function to CategoryFramework
              categories: categories,
              onCategorySelected: updateCategory,
              selectedCategory: selectedCategory,
              selectedColor: selectedColor,
            ),
            const Gap(22),
            DateTimeWidget(
                titleText: 'Should this repeat?',
                valueText: ref.watch(repeatingProvider),
                iconSection: CupertinoIcons.arrow_counterclockwise,
                onTap: () async {}),
          ]),

          //Button Section

          const Gap(12),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue.shade800,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const Gap(20),
              Expanded(
                child: Builder(builder: (context) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      final toDoModel = ToDoModel(
                          titleTask: titleController.text.trim(),
                          description: descriptionController.text.trim(),
                          category: ref.read(categoryProvider),
                          dateTask: ref.read(dateProvider),
                          timeTask: ref.read(timeProvider),
                          isDone: false);

                      ref
                          .read(serviceProvider)
                          .addNewTask(toDoModel, uID!, selectedCategory);

                      // ignore: avoid_print
                      print('Data is saving');

                      titleController.clear();
                      descriptionController.clear();
                      ref
                          .read(categoryProvider.notifier)
                          .update((state) => 'Select Category');
                      ref
                          .read(dateProvider.notifier)
                          .update((state) => 'mm / dd / yy');
                      ref
                          .read(timeProvider.notifier)
                          .update((state) => 'hh : mm');
                      Navigator.pop(context);
                    },
                    child: const Text('Create'),
                  );
                }),
              ),
            ],
          )
        ]));
  }
}
