import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../auth_pages/auth_provider.dart';
import 'provider/taskproviders/selected_category_providers.dart';
import 'provider/taskproviders/service_provider.dart';
import 'provider/taskproviders/task_providers.dart';
import 'task_service.dart';
import 'taskmodels/task_model.dart';
import 'widgets/category_widget_all/category.model.dart';
import 'widgets/category_widget_all/category_widget.dart';
import 'widgets/constants/constants.dart';
import 'widgets/task_widgets.dart';
import 'widgets/textfield_widget.dart';

class EditTaskModel extends ConsumerStatefulWidget {
  final TaskModel task;

  const EditTaskModel({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditTaskModelState();
}

@override
class _EditTaskModelState extends ConsumerState<EditTaskModel> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    titleController = TextEditingController(text: task.taskTitle);
    descriptionController = TextEditingController(text: task.description);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = ref.watch(categoryNameRadioProvider).categoryName;
    final categoryColor = ref.watch(categoryNameRadioProvider).colorHex;
    final task = widget.task;
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
            'Edit Task',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        Divider(
          thickness: 1.2,
          color: Colors.grey.shade600,
        ),
        const Gap(12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Current Task Title',
              style: AppStyle.headingOne,
            ),
            Container(
              constraints: BoxConstraints.tight(const Size(90, 25)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                ),
                onPressed: () {
                  final userID = ref.read(authStateProvider).maybeWhen(
                        data: (user) => user?.uid,
                        orElse: () => null,
                      );
                  ref.read(serviceProvider).deleteTask(
                        userID!,
                        task.categoryID,
                        task.docID,
                      );
                  ref.read(taskListProvider.notifier).removeTask(task);

                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Delete Task',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
        const Gap(6),
        TextFieldWidget(
          maxLine: 1,
          hintText: 'Edit Task Name',
          txtController: titleController,
        ),
        const Gap(12),
        const Text('Current Description', style: AppStyle.headingOne),
        const Gap(6),
        TextFieldWidget(
          maxLine: 3,
          hintText: 'Edit Descriptions',
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
              valueText: task.dateTask,
              iconSection: CupertinoIcons.calendar,
              onTap: () async {
                final getValue = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2025));

                if (getValue != null) {
                  final format = DateFormat.yMEd();
                  ref
                      .read(dateProvider.notifier)
                      .update((state) => format.format(getValue));
                }
              },
            ),
            const Gap(22),
            DateTimeWidget(
              titleText: 'Time',
              valueText: task.timeTask,
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
            selectedCategoryColor: categoryColor,
            selectedCategoryName: categoryName,
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
                onPressed: () {
                  ref.read(taskRadioProvider.notifier).update((state) => null);
                  titleController.clear();
                  descriptionController.clear();

                  ref.read(categoryNameRadioProvider.notifier).update((state) =>
                      UserCreatedCategoryModel(
                          categoryID: '',
                          categoryName: "Select Category",
                          colorHex: ''));
                  ref
                      .read(dateProvider.notifier)
                      .update((state) => 'mm / dd / yy');
                  ref.read(timeProvider.notifier).update((state) => 'hh : mm');
                  Navigator.pop(context);
                },
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
                    final selectedCategory =
                        ref.read(categoryNameRadioProvider);
                    final toDoModel = TaskModel(
                      taskTitle: task.taskTitle,
                      description: task.description,
                      categoryID: task.categoryID,
                      categoryName: task.categoryName,
                      categoryColorHex: task.categoryColorHex,
                      dateTask: task.dateTask,
                      timeTask: task.timeTask,
                      isDone: task.isDone,
                    );

                    final uID = FirebaseAuth.instance.currentUser?.uid;

                    if (uID != null && selectedCategory.categoryID.isNotEmpty) {
                      ref.read(serviceProvider).addNewTask(
                            toDoModel,
                            uID,
                            selectedCategory.categoryID,
                          );
                    }

                    // ignore: avoid_print
                    print('Data is saving');

                    ref
                        .read(taskRadioProvider.notifier)
                        .update((state) => null);
                    Navigator.pop(context);
                  },
                  child: const Text('Create'),
                );
              }),
            ),
          ],
        )
      ]),
    );
  }
}
