import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:np_app/backend/tasks(all)/provider/taskproviders/service_provider.dart';

import '../taskmodels/task_model.dart';

class CardToolListWidget extends ConsumerWidget {
  const CardToolListWidget({
    required this.getIndex,
    required this.getCatIndex,
    required this.categoryID,
    required this.todoData,
    Key? key,
  }) : super(key: key);

  final int getIndex;
  final int getCatIndex;
  final String categoryID;
  final List<TaskModel?> todoData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color categoryColor = Colors.white;
    StreamBuilder<List<TaskModel?>>(
        stream: loadTaskData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final tasks = snapshot.data!;
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                Container(
                  decoration: BoxDecoration(
                      color: categoryColor,
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
                        ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: IconButton(
                                  icon: const Icon(
                                    CupertinoIcons.delete,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    final userID =
                                        FirebaseAuth.instance.currentUser?.uid;
                                    final taskTitle = task!.taskTitle;
                                    ref.read(serviceProvider).deleteTask(
                                        userID!, categoryID, taskTitle);
                                  },
                                ),
                                title: Text(
                                  task!.taskTitle,
                                  maxLines: 1,
                                  style: TextStyle(
                                      decoration: task.isDone
                                          ? TextDecoration.lineThrough
                                          : null),
                                ),
                                subtitle: Text(
                                  task.description,
                                  maxLines: 1,
                                ),
                                trailing: Transform.scale(
                                  scale: 1.5,
                                  child: Checkbox(
                                      activeColor: Colors.blue.shade800,
                                      shape: const CircleBorder(),
                                      value: task.isDone,
                                      // ignore: avoid_print
                                      onChanged: (value) {
                                        final userID = FirebaseAuth
                                            .instance.currentUser?.uid;
                                        final categoryID = FirebaseFirestore
                                            .instance
                                            .collection('users')
                                            .doc(userID)
                                            .collection('Categories')
                                            .id;
                                        final taskID = task.docID;
                                        if (userID != null) {
                                          ref.read(serviceProvider).updateTask(
                                              userID,
                                              categoryID,
                                              taskID,
                                              value);
                                        }
                                      }),
                                ),
                              );
                            }),
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
                                  const Text('Today'),
                                  const Gap(12),
                                  Text(todoData[getIndex]!.timeTask)
                                ],
                              )
                            ],
                          ),
                        )
                      ]),
                ))
              ]),
            );
          }
          return const SizedBox();
        });
    return const SizedBox();
  }
}

class DisplayTask extends ConsumerWidget {
  const DisplayTask({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    StreamBuilder<List<TaskModel?>>(
      stream: loadTaskData(), // Use the correct stream here
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final tasks = snapshot.data!;

          // Now you can use 'tasks' to access task data in the UI
          return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return CardToolListWidget(
                  getIndex: index,
                  categoryID: task!.category,
                  getCatIndex: index,
                  todoData: const [],
                );
              });
        }
        return const SizedBox();
      },
    );
    return const DisplayDefaultTask();
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
