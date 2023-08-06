import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:np_app/backend/tasks(all)/provider/taskproviders/service_provider.dart';

class CardToolListWidget extends ConsumerWidget {
  const CardToolListWidget({required this.getIndex, Key? key})
      : super(key: key);

  final int getIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color categoryColor = Colors.white;

    final todoData = ref.watch(fetchDataProvider);
    return todoData.when(
      data: (todoData) {
        final getCategory = todoData[getIndex].category;
        switch (getCategory) {
          case 'Learning':
            categoryColor = Colors.green;
            break;

          case 'Working':
            categoryColor = Colors.blue.shade700;
            break;

          case 'General':
            categoryColor = Colors.amber.shade700;
            break;
        }

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
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: IconButton(
                        icon: const Icon(
                          CupertinoIcons.delete,
                          size: 20,
                        ),
                        onPressed: () {
                          final userID = FirebaseAuth.instance.currentUser?.uid;
                          ref.read(serviceProvider).deleteTask(
                              userID!, todoData[getIndex].docID, getCategory);
                        },
                      ),
                      title: Text(
                        todoData[getIndex].titleTask,
                        maxLines: 1,
                        style: TextStyle(
                            decoration: todoData[getIndex].isDone
                                ? TextDecoration.lineThrough
                                : null),
                      ),
                      subtitle: Text(
                        todoData[getIndex].description,
                        maxLines: 1,
                      ),
                      trailing: Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                          activeColor: Colors.blue.shade800,
                          shape: const CircleBorder(),
                          value: todoData[getIndex].isDone,
                          // ignore: avoid_print
                          onChanged: (value) {
                            final userID =
                                FirebaseAuth.instance.currentUser?.uid;
                            ref.read(serviceProvider).updateTask(
                                  userID!,
                                  todoData[getIndex].docID,
                                  getCategory,
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
                              const Text('Today'),
                              const Gap(12),
                              Text(todoData[getIndex].timeTask)
                            ],
                          )
                        ],
                      ),
                    )
                  ]),
            ))
          ]),
        );
      },
      error: (error, stackTrace) => Center(
        child: Text(stackTrace.toString()),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class DisplayTask extends ConsumerWidget {
  const DisplayTask({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoData = ref.watch(fetchDataProvider);
    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: todoData.value?.length ?? 0,
        shrinkWrap: true,
        itemBuilder: (context, index) => CardToolListWidget(getIndex: index),
      ),
    );
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
