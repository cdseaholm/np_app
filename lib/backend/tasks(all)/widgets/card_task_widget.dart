import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:np_app/backend/tasks(all)/provider/taskproviders/service_provider.dart';

import '../../auth_pages/auth_provider.dart';

class CardToolListWidget extends ConsumerWidget {
  const CardToolListWidget({required this.getIndex, Key? key})
      : super(key: key);

  final int getIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color categoryColor = Colors.white;

    final todoData = ref.watch(fetchDataProvider);
    if (kDebugMode) {
      print('todoData: $todoData');
    }
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
                          final userID = ref.read(authStateProvider).maybeWhen(
                                data: (user) => user?.uid,
                                orElse: () => null,
                              );
                          ref
                              .read(serviceProvider)
                              .deleteTask(userID!, todoData[getIndex].docID);
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
                                ref.read(authStateProvider).maybeWhen(
                                      data: (user) => user?.uid,
                                      orElse: () => null,
                                    );
                            ref.read(serviceProvider).updateTask(
                                  userID!,
                                  todoData[getIndex].docID,
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
