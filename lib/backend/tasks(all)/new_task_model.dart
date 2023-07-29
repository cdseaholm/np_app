import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:np_app/backend/tasks(all)/widgets/constants/app_style.dart';
import 'package:np_app/backend/models/todo_model.dart';
import 'package:np_app/backend/tasks(all)/widgets/date_time_widget.dart';
import 'package:np_app/backend/tasks(all)/widgets/radio_widget.dart';
import 'package:np_app/backend/tasks(all)/provider/taskproviders/date_time_provider.dart';
import 'package:np_app/backend/tasks(all)/provider/taskproviders/radio_provider.dart';
import 'package:np_app/backend/tasks(all)/provider/taskproviders/service_provider.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import 'widgets/textfield_widget.dart';

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
    final dateProv = ref.watch(dateProvider);
    final uID = FirebaseAuth.instance.currentUser?.uid;
    if (kDebugMode) {
      print('uID: $uID');
    }

    if (uID == null) {
      if (kDebugMode) {
        print('User is not signed in');
      }
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
        height: MediaQuery.of(context).size.height * 0.75,
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
          const Text('Category', style: AppStyle.headingOne),
          Row(
            children: [
              Expanded(
                child: RadioWidget(
                  categColor: Colors.green,
                  titleRadio: 'LRN',
                  valueInput: 1,
                  onChangeValue: () =>
                      ref.read(radioProvider.notifier).update((state) => 1),
                ),
              ),
              Expanded(
                child: RadioWidget(
                  categColor: Colors.blue.shade700,
                  titleRadio: 'WRK',
                  valueInput: 2,
                  onChangeValue: () =>
                      ref.read(radioProvider.notifier).update((state) => 2),
                ),
              ),
              Expanded(
                child: RadioWidget(
                  categColor: Colors.amberAccent.shade700,
                  titleRadio: 'GEN',
                  valueInput: 3,
                  onChangeValue: () =>
                      ref.read(radioProvider.notifier).update((state) => 3),
                ),
              ),
            ],
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
                    onPressed: () {
                      final getRadioValue = ref.read(radioProvider);
                      String category = '';

                      switch (getRadioValue) {
                        case 1:
                          category = 'Learning';
                          break;
                        case 2:
                          category = 'Working';
                          break;
                        case 3:
                          category = 'General';
                          break;
                      }

                      final toDoModel = ToDoModel(
                          titleTask: titleController.text.trim(),
                          description: descriptionController.text.trim(),
                          category: category,
                          dateTask: ref.read(dateProvider),
                          timeTask: ref.read(timeProvider),
                          isDone: false);

                      ref.read(serviceProvider).addNewTask(toDoModel, uID!);

                      // ignore: avoid_print
                      print('Data is saving');

                      titleController.clear();
                      descriptionController.clear();
                      ref.read(radioProvider.notifier).update((state) => 0);
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