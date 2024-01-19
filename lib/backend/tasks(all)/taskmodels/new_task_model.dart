import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:np_app/backend/tasks(all)/widgets/constants/constants.dart';
import 'package:np_app/backend/tasks(all)/taskmodels/task_model.dart';
import 'package:np_app/backend/tasks(all)/repeat/repeat_widget.dart';
import 'package:np_app/backend/tasks(all)/widgets/date_time_widgets.dart';
import 'package:np_app/backend/tasks(all)/provider/taskproviders/task_providers.dart';
import '../../../main.dart';
import '../provider/taskproviders/clean_providers.dart';
import '../provider/taskproviders/selected_category_providers.dart';
import '../provider/taskproviders/service_provider.dart';
import '../repeat/repeat_notifiers.dart';
import '../widgets/category_widget_all/category_service.dart';
import '../widgets/category_widget_all/category_widget.dart';
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
  List<String> newTaskSelectedDays = [];
  final TaskModel noTask = TaskModel(
      taskTitle: '',
      description: '',
      categoryID: '',
      categoryName: '',
      categoryColorHex: '',
      dateTask: '',
      timeTask: '',
      isDone: false,
      repeatShown: '',
      repeatingDays: [],
      repeatingFrequency: '',
      stopDate: '',
      creationDate: '',
      status: '');

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

  @override
  Widget build(BuildContext context) {
    var stopDate = repeatUntilNotifier.value;
    final dateProv = ref.watch(dateProvider);
    final uID = FirebaseAuth.instance.currentUser?.uid;
    final creationDate = TimeOfDay.fromDateTime(DateTime.now());
    final category = ref.watch(selectedCategoryProvider);
    var repeatingDays = ref.watch(repeatingOptionDays);
    var repeatingFrequency = ref.watch(repeatingOptionFrequency);
    var repeatShown = ref.watch(repeatShownProvider);

    if (uID == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.white,
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
            color: Colors.grey.shade600,
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
                      firstDate: DateTime(DateTime.now().year - 2),
                      lastDate: DateTime(DateTime.now().year + 4));

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
                selectedCategoryColor: category.colorHex,
                selectedCategoryName: category.categoryName),
            const Gap(22),
            RepeatingWidget(previousPage: PreviousPage.newTask, task: noTask),
          ]),

          //Button Section

          const Gap(12),

          Row(children: [
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
                  titleController.clear();
                  descriptionController.clear();

                  ProvidersClear().clearNewTaskProvidersCancel(ref);
                  setState(() {
                    frequencyNotifier.value = 'No';
                    repeatUntilNotifier.value = 'Until?';
                    selectedDaysNotifier.value = [];
                    selectedRepeatingDaysList.clear();
                    showDaysHint = true;
                  });

                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ),
            const Gap(20),
            Expanded(child: Builder(builder: (context) {
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
                  final toDoModel = TaskModel(
                    taskTitle: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                    categoryID: category.categoryID,
                    categoryName: category.categoryName,
                    categoryColorHex: category.colorHex,
                    dateTask: ref.read(dateProvider),
                    timeTask: ref.read(timeProvider),
                    isDone: false,
                    repeatShown: repeatShown,
                    repeatingDays: repeatingDays,
                    repeatingFrequency: repeatingFrequency,
                    stopDate: stopDate,
                    creationDate: creationDate.toString(),
                    status: 'Upcoming',
                  );

                  final uID = FirebaseAuth.instance.currentUser?.uid;

                  if (uID != null) {
                    if (category.categoryName == 'No Category') {
                      await addNoCategory(context, ref, category.colorHex,
                          category.categoryName);
                      final noCategory = ref.read(selectedCategoryProvider);
                      final newTaskReference = await ref
                          .read(serviceProvider)
                          .addNewTask(
                              ref, toDoModel, uID, noCategory.categoryID);

                      toDoModel.docID = newTaskReference.id;
                    } else {
                      if (category.categoryID.isNotEmpty) {
                        final newTaskReference =
                            await ref.read(serviceProvider).addNewTask(
                                  ref,
                                  toDoModel,
                                  uID,
                                  category.categoryID,
                                );

                        toDoModel.docID = newTaskReference.id;
                      } else {
                        return;
                      }
                    }
                  } else if (uID != null && category.categoryID.isNotEmpty) {
                    final newTaskReference =
                        await ref.read(serviceProvider).addNewTask(
                              ref,
                              toDoModel,
                              uID,
                              category.categoryID,
                            );
                    toDoModel.docID = newTaskReference.id;

                    ref.read(taskListProvider.notifier).updateTasks(
                      [...ref.read(taskListProvider), toDoModel],
                    );
                  }

                  ref.read(fetchCategoryTasks).isRefreshing;

                  ProvidersClear().newTaskProviderClearCreate(
                      titleController, descriptionController, ref);
                  setState(() {
                    frequencyNotifier.value = 'No';
                    repeatUntilNotifier.value = 'Until?';
                    selectedDaysNotifier.value = [];
                    selectedRepeatingDaysList.clear();
                    showDaysHint = true;
                  });

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('Create'),
              );
            }))
          ])
        ]));
  }
}
