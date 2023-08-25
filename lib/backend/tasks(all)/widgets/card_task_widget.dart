// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gap/gap.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:np_app/backend/tasks(all)/provider/taskproviders/selected_category_providers.dart';
import 'package:np_app/backend/tasks(all)/widgets/category_widget_all/category.model.dart';

import '../../auth_pages/auth_provider.dart';
import '../edit_task.dart';
import '../provider/taskproviders/service_provider.dart';
import '../task_service.dart';

class CardToolListWidget extends ConsumerWidget {
  const CardToolListWidget({required this.getIndex, Key? key})
      : super(key: key);

  final int getIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider);
    final currentTask = tasks[getIndex];
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
                      onPressed: () {
                        ref.read(categoryNameRadioProvider.notifier).state =
                            UserCreatedCategoryModel(
                          categoryID: currentTask.categoryID,
                          categoryName: currentTask.categoryName,
                          colorHex: currentTask.categoryColorHex,
                        );
                        showModalBottomSheet(
                          isDismissible: false,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          context: context,
                          builder: (context) =>
                              EditTaskModel(task: currentTask),
                        );
                      },
                      child: const Text(
                        'Edit Task',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    title: Text(
                      currentTask.taskTitle,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          decoration: currentTask.isDone
                              ? TextDecoration.lineThrough
                              : null),
                    ),
                    subtitle: Text(
                      currentTask.description,
                      maxLines: 1,
                    ),
                    trailing: Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                        activeColor: Colors.blue.shade800,
                        shape: const CircleBorder(),
                        value: currentTask.isDone,
                        // ignore: avoid_print
                        onChanged: (value) {
                          final userID = ref.read(authStateProvider).maybeWhen(
                                data: (user) => user?.uid,
                                orElse: () => null,
                              );
                          ref.read(serviceProvider).updateTask(
                                userID!,
                                currentTask.categoryID,
                                currentTask.docID,
                                value,
                              );
                        },
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -12),
                    child: Column(
                      children: [
                        Divider(
                          thickness: 1.5,
                          color: Colors.grey.shade200,
                        ),
                        Row(
                          children: [
                            Text(
                              formatTaskDate(currentTask.dateTask),
                            ),
                            const Gap(12),
                            Text(currentTask.timeTask)
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

class DisplayDefaultTask extends ConsumerWidget {
  const DisplayDefaultTask({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 4),
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Create a Task to see it here!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "Click '+ New Task' above to get started",
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

String formatTaskDate(String date) {
  final taskDate = DateFormat('E, M/d/yyyy').parse(date);
  final currentDate = DateTime.now();
  final difference = taskDate.difference(currentDate).inDays;

  if (difference <= 60) {
    return DateFormat("E, MMM d").format(taskDate);
  } else {
    return DateFormat('yMd').format(taskDate);
  }
}
