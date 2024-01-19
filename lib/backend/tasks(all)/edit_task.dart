import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:np_app/backend/tasks(all)/repeat/repeat_notifiers.dart';
import '../../main.dart';
import '../auth_pages/auth_provider.dart';
import 'provider/taskproviders/clean_providers.dart';
import 'provider/taskproviders/selected_category_providers.dart';
import 'provider/taskproviders/service_provider.dart';
import 'provider/taskproviders/task_providers.dart';
import 'taskmodels/task_model.dart';
import 'widgets/category_widget_all/category_widget.dart';
import 'widgets/constants/constants.dart';
import 'widgets/date_time_widgets.dart';
import 'repeat/repeat_widget.dart';
import 'widgets/status/status_providers.dart';
import 'widgets/textfield_widget.dart';

class EditTaskModel extends ConsumerStatefulWidget {
  final TaskModel taskToUpdate;
  final Function(TaskModel) onTaskUpdated;
  const EditTaskModel(
      {Key? key, required this.taskToUpdate, required this.onTaskUpdated})
      : super(key: key);

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
    var taskToUpdate = widget.taskToUpdate;

    titleController = TextEditingController(
      text: taskToUpdate.taskTitle,
    );
    descriptionController = TextEditingController(
      text: taskToUpdate.description,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var taskToUpdate = widget.taskToUpdate;
    var category = ref.watch(selectedCategoryProvider);

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
                onPressed: () async {
                  final userID = ref.read(authStateProvider).maybeWhen(
                        data: (user) => user?.uid,
                        orElse: () => null,
                      );
                  if (userID != null) {
                    try {
                      ref
                          .read(taskListProvider.notifier)
                          .removeTask(taskToUpdate);
                    } catch (error) {
                      if (kDebugMode) {
                        print('Error deleting task: $error');
                      }
                    }
                  }

                  ProvidersClear().clearEditTask(ref);
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
              valueText: taskToUpdate.dateTask,
              iconSection: CupertinoIcons.calendar,
              onTap: () async {
                final getValue = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 2),
                    lastDate: DateTime(DateTime.now().year + 4));

                if (getValue != null) {
                  final format = DateFormat.yMEd();
                  final newDate = format.format(getValue);
                  setState(() {
                    taskToUpdate.dateTask = newDate;
                  });
                }
              },
            ),
            const Gap(22),
            DateTimeWidget(
              titleText: 'Time',
              valueText: taskToUpdate.timeTask,
              iconSection: CupertinoIcons.clock,
              onTap: () async {
                final getTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (getTime != null) {
                  // ignore: use_build_context_synchronously
                  final newTime = getTime.format(context);

                  setState(() {
                    taskToUpdate.timeTask = newTime;
                  });
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
            selectedCategoryName: category.categoryName,
          ),
          const Gap(22),
          RepeatingWidget(
            previousPage: PreviousPage.editTask,
            task: taskToUpdate,
          ),
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
                  ProvidersClear().clearEditTask(ref);
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
                    final userID = FirebaseAuth.instance.currentUser?.uid;
                    final newTitle = titleController.text;
                    final newDescription = descriptionController.text;
                    final status = determineTaskStatus(taskToUpdate.dateTask);

                    final newRepeatDays = ref.read(repeatingOptionDays);

                    final newRepeatFrequency =
                        ref.read(repeatingOptionFrequency);
                    final newRepeatShown = ref.read(repeatShownProvider);
                    final newRepeatUntil = ref.read(stopDateProvider);
                    final updatedTask =
                        await ref.read(updateTaskProvider).updateTaskFields(
                              userID: userID!,
                              categoryID: category.categoryID,
                              categoryName: category.categoryName,
                              taskID: taskToUpdate.docID,
                              newTitle: newTitle,
                              newDescription: newDescription,
                              newDate: taskToUpdate.dateTask,
                              newTime: taskToUpdate.timeTask,
                              newStatus: status,
                              newRepeatDays: newRepeatDays,
                              newRepeatShown: newRepeatShown,
                              newRepeatFrequency: newRepeatFrequency,
                              newRepeatUntil: newRepeatUntil,
                            );

                    if (updatedTask != null) {
                      ToDoService().updateTasksList(ref, updatedTask);
                    }

                    ref
                        .read(taskListProvider.notifier)
                        .updateTasks([...ref.read(taskListProvider)]);

                    ref.read(fetchCategoryTasks).isRefreshing;

                    ProvidersClear().clearEditTask(ref);
                    setState(() {
                      selectedRepeatingDaysList = [];
                      frequencyNotifier.value = 'No';
                      repeatUntilNotifier.value = 'Until?';
                      selectedDaysNotifier.value = [];
                      showDaysHint = true;
                    });

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Update'),
                );
              }),
            ),
          ],
        )
      ]),
    );
  }
}
