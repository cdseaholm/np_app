import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_app/backend/tasks(all)/provider/taskproviders/selected_category_providers.dart';
import 'package:np_app/backend/tasks(all)/provider/taskproviders/task_providers.dart';

import 'package:np_app/backend/tasks(all)/widgets/filters/filter_services.dart';

import '../category_widget_all/category_widget.dart';
import 'filter_logic.dart';

class CustomFilterButton extends StatefulHookConsumerWidget {
  const CustomFilterButton({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomFilterButtonState();
}

class _CustomFilterButtonState extends ConsumerState<CustomFilterButton> {
  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    var tasks = ref.watch(taskListProvider);
    var filterByText = ref.watch(filterProvider).value.toString();
    var selectedCategory = ref.watch(selectedCategoryProvider).categoryName;
    var categoryFilter = ref.watch(categoryFilterProvider).value.toString();
    final taskFilterByList = [
      'All',
      'Category',
      'Date',
      'New -> Old',
      'Old -> New',
      'Overdue',
      'Upcoming',
    ];

    return PopupMenuButton<String>(
      onSelected: (String filterBy) async {
        if (filterBy != filterByText) {
          await FilterService().updateFilter(ref, filterBy);
          if (filterBy != filterByText && filterBy == 'Category') {
            const SelectCategoryMethod();
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userID)
                .update({'categoryFilter': selectedCategory});
          }
        }

        if (filterBy == 'Category') {
          FilterStates().sortByCategory(tasks, categoryFilter);
        } else if (filterBy == 'Completed') {
          FilterStates().sortByCompleted(tasks);
        } else if (filterBy == 'Date') {
          FilterStates().sortByDate(tasks);
        } else if (filterBy == 'New \u{2191}') {
          FilterStates().sortNewestToOldest(tasks);
        } else if (filterBy == 'New \u{2193}') {
          FilterStates().sortOldestToNewest(tasks);
        } else if (filterBy == 'Overdue') {
          FilterStates().sortByOverdue(tasks);
        } else if (filterBy == 'Upcoming') {
          FilterStates().sortByUpcoming(tasks);
        }

        if (kDebugMode) {
          print('sorted: ${tasks.map((task) => task.taskTitle)}');
        }

        ref.read(taskListProvider.notifier).updateTasks(tasks);
      },
      itemBuilder: (context) {
        return taskFilterByList.map((filterBy) {
          return PopupMenuItem<String>(
            value: filterBy,
            child: Text(filterBy),
          );
        }).toList();
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 4,
        child: Flex(
            clipBehavior: Clip.hardEdge,
            direction: Axis.horizontal,
            children: [
              Column(children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  padding: const EdgeInsets.only(left: 5.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(filterByText),
                          ],
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ]),
                ),
              ]),
            ]),
      ),
    );
  }
}
