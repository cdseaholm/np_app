import 'package:flutter/material.dart';

class CustomFilterButton extends StatelessWidget {
  const CustomFilterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskFilterByList = [
      'Category',
      'Date',
      'Overdue',
      'Incomplete',
      'Upcoming',
    ];

    return PopupMenuButton<String>(
      onSelected: (String filterBy) {
        // Handle the selected filter option
        // You can call a function to filter tasks based on the selected option.
      },
      itemBuilder: (context) {
        return taskFilterByList.map((filterBy) {
          return PopupMenuItem<String>(
            value: filterBy,
            child: Text(filterBy),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_drop_down),
            SizedBox(width: 4),
            Text('Filter By'),
          ],
        ),
      ),
    );
  }
}
