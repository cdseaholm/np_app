import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:np_app/backend/tasks(all)/provider/taskproviders/service_provider.dart';

import 'new_task_model.dart';
import 'widgets/card_task_widget.dart';

class Tasks extends ConsumerWidget {
  const Tasks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoData = ref.watch(fetchDataProvider);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(children: [
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Today\'s Task',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    DateFormat('EEEE, MMMM d').format(DateTime.now()),
                    style: const TextStyle(color: Colors.grey),
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
                onPressed: () => showModalBottomSheet(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  context: context,
                  builder: (context) => const AddNewTaskModel(),
                ),
                child: const Text('+ New Task'),
              ),

              // Card list task
            ],
          ),
          const Gap(20),
          if (todoData.value != null)
            SingleChildScrollView(
              child: ListView.builder(
                itemCount: todoData.value?.length ?? 0,
                shrinkWrap: true,
                itemBuilder: (context, index) =>
                    CardToolListWidget(getIndex: index),
              ),
            ),
        ]),
      )),
    );
  }
}
