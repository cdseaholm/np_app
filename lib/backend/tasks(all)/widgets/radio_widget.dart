import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/taskproviders/task_providers.dart';

class RadioWidget extends ConsumerWidget {
  const RadioWidget({
    Key? key,
    required this.categColor,
    required this.titleRadio,
    required this.valueInput,
  }) : super(key: key);

  final Color categColor;
  final String titleRadio;
  final String valueInput;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(categoryProvider);

    return DropdownButton<String>(
      value: category,
      items: [
        DropdownMenuItem(
          value: category,
          child: ListTile(
            title: Transform.translate(
              offset: const Offset(-22, 0),
              child: Text(
                titleRadio,
                style:
                    TextStyle(color: categColor, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ],
      onChanged: (value) {
        ref.read(categoryProvider.notifier).update((state) => category);
        valueInput;
      },
      underline: const SizedBox(), // Remove the underline
      isExpanded: true, // Make the dropdown menu expand to fit the content
      hint: const SizedBox
          .shrink(), // Hide the hint text when a value is selected
    );
  }
}
