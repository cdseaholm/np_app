// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_app/backend/tasks(all)/provider/taskproviders/service_provider.dart';
import 'package:np_app/backend/tasks(all)/repeat/repeat_notifiers.dart';
import '../edit_task.dart';
import '../provider/taskproviders/selected_category_providers.dart';
import '../provider/taskproviders/task_providers.dart';
import '../taskmodels/task_model.dart';
import 'category_widget_all/category.model.dart';
import 'constants/constants.dart';
import 'status/status_providers.dart';

class CardToolListWidget extends ConsumerStatefulWidget {
  const CardToolListWidget({required this.getIndex, Key? key})
      : super(key: key);

  final int getIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CardToolListWidgetState();
}

class _CardToolListWidgetState extends ConsumerState<CardToolListWidget> {
  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskListProvider);
    var currentTask = tasks[widget.getIndex];
    final isDoneNotifier = ValueNotifier<bool>(currentTask.isDone);
    var statusText = currentTask.status;
    final statusNotifier = ValueNotifier<String>(currentTask.dateTask);

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: .5)),
        child: Row(children: [
          Container(
            decoration: BoxDecoration(
                color: colorFromHex(currentTask.categoryColorHex),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                )),
            width: 30,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: BorderSide.strokeAlignCenter),
                          maximumSize: const Size(80, 45),
                          backgroundColor: const Color(0xFFD5E8FA),
                          foregroundColor: Colors.blue.shade800,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: () async {
                        updateProviders(currentTask, ref);

                        await showModalBottomSheet(
                          showDragHandle: true,
                          isDismissible: false,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          context: context,
                          builder: (context) => EditTaskModel(
                            taskToUpdate: currentTask,
                            onTaskUpdated: (task) {
                              setState(() {
                                currentTask = task;
                              });
                            },
                          ),
                        );
                      },
                      child: const Text(
                        'Edit Task',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    title: ValueListenableBuilder<bool>(
                        valueListenable: isDoneNotifier,
                        builder: (context, isDone, child) {
                          return Text(
                            currentTask.taskTitle,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              decoration: isDoneNotifier.value
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          );
                        }),
                    subtitle: Text(
                      currentTask.description,
                      maxLines: 1,
                    ),
                    trailing: Transform.scale(
                        scale: 1.2,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: ValueListenableBuilder<bool>(
                            valueListenable: isDoneNotifier,
                            builder: (context, isDone, child) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Checkbox(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    activeColor: Colors.blue.shade800,
                                    shape: const CircleBorder(),
                                    value: isDone,
                                    onChanged: (value) async {
                                      final userID = FirebaseAuth
                                          .instance.currentUser?.uid;
                                      ref.read(serviceProvider).updateDoneTask(
                                            userID!,
                                            currentTask.categoryID,
                                            currentTask.docID,
                                            value,
                                          );
                                      final newStatus =
                                          value! ? 'Completed' : statusText;
                                      await UpdateTaskService()
                                          .updateTaskFields(
                                        userID: userID,
                                        categoryID:
                                            currentTask.categoryColorHex,
                                        categoryName: currentTask.categoryName,
                                        taskID: currentTask.docID,
                                        newStatus: newStatus,
                                      );

                                      if (value) {
                                        statusNotifier.value = 'Completed';
                                      } else {
                                        statusNotifier.value = statusText;
                                      }

                                      isDoneNotifier.value = value;
                                    },
                                  )
                                ],
                              );
                            },
                          ),
                        )),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -12),
                    child: Column(
                      children: [
                        const Divider(
                          thickness: 1.5,
                          color: Colors.black38,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(children: [
                              if (currentTask.dateTask == 'mm/dd/yy' &&
                                  currentTask.timeTask == 'hh:mm')
                                const Text('No Date or Time set')
                              else if (currentTask.dateTask != 'mm/dd/yy' &&
                                  currentTask.timeTask == 'hh:mm')
                                Text(formatTaskDate(currentTask.dateTask))
                              else if (currentTask.dateTask == 'mm/dd/yy' &&
                                  currentTask.timeTask != 'hh:mm')
                                Text('No Date Set, ${currentTask.timeTask}')
                              else if (currentTask.dateTask != 'mm/dd/yy' &&
                                  currentTask.timeTask != 'hh:mm')
                                Text(
                                    '${formatTaskDate(currentTask.dateTask)} ${currentTask.timeTask}'),
                            ]),
                            ValueListenableBuilder<String>(
                                valueListenable: statusNotifier,
                                builder: (context, status, child) {
                                  if (currentTask.dateTask == 'mm/dd/yy') {
                                    return Container();
                                  } else if (currentTask.dateTask !=
                                      'mm/dd/yy') {
                                    final taskStatus = determineTaskStatus(
                                        currentTask.dateTask);

                                    // Define the style based on the task status
                                    TextStyle textStyle;
                                    if (taskStatus == 'Overdue') {
                                      textStyle = const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13);
                                    } else if (taskStatus == 'Completed') {
                                      textStyle = const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13);
                                    } else if (taskStatus == 'Due Today') {
                                      textStyle = const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13);
                                    } else if (taskStatus == 'Upcoming') {
                                      textStyle = const TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13);
                                    } else {
                                      textStyle = const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13);
                                    }
                                    return Flexible(
                                      child: Column(
                                        children: [
                                          Text(
                                            taskStatus,
                                            style: textStyle,
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return Container();
                                })
                          ],
                        )
                      ],
                    ),
                  )
                ]),
          ))
        ]));
  }
}

Future<void> updateProviders(TaskModel task, WidgetRef ref) async {
  List<String> array = await loadArray(task);

  selectedRepeatingDaysList = array;

  if (kDebugMode) {
    print('list: ${selectedRepeatingDaysList.join(', ').toString()}');
  }

  ref.read(selectedCategoryProvider.notifier).state = UserCreatedCategoryModel(
    categoryID: task.categoryID,
    categoryName: task.categoryName,
    colorHex: task.categoryColorHex,
  );
  ref
      .read(repeatingOptionDays.notifier)
      .update((state) => selectedRepeatingDaysList);

  ref
      .read(repeatingOptionFrequency.notifier)
      .update((state) => task.repeatingFrequency);
  ref.read(stopDateProvider.notifier).update((state) => task.stopDate);
  ref.read(repeatShownProvider.notifier).update((state) => task.repeatShown);
}

Future<List<String>> loadArray(TaskModel task) async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Categories')
        .doc(task.categoryID)
        .collection('Tasks')
        .doc(task.docID)
        .get();

    if (snapshot.exists && snapshot.data() != null) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null &&
          data.containsKey('repeatingDays') &&
          data['repeatingDays'] is List<dynamic>) {
        var repeatingDaysArray = data['repeatingDays'] as List<dynamic>;

        List<String> array = [];

        for (var day in repeatingDaysArray) {
          if (day is String) {
            array.add(day);
          }
        }

        return array;
      }
    }

    return [];
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return [];
  }
}
