// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:np_app/backend/tasks(all)/provider/taskproviders/task_providers.dart';
import 'taskmodels/new_task_model.dart';
import 'widgets/card_task_widget.dart';
import 'widgets/default_task.dart';
import 'widgets/filters/filter_widget.dart';

class Tasks extends ConsumerWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Today\'s Tasks',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      DateFormat('EEEE, MMMM d').format(DateTime.now()),
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD5E8FA),
                      foregroundColor: Colors.blue.shade800,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () => showModalBottomSheet<void>(
                    showDragHandle: true,
                    isDismissible: false,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    context: context,
                    builder: (context) => const AddNewTaskModel(),
                  ).whenComplete(() => null),
                  child: const Text('+ New Task'),
                ),
              ],
            ),
            const Gap(10),
            const Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text('Filter By:'),
              Gap(1),
              CustomFilterButton(),
            ]),
            const Divider(
              thickness: .6,
              color: Colors.black,
            ),
            const Gap(10),
            if (tasks.isEmpty)
              const DisplayDefaultTask()
            else
              Expanded(
                  child: ListView.builder(
                itemCount: tasks.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return CardToolListWidget(getIndex: index);
                },
              ))
          ],
        ),
      ),
    );
  }
}
