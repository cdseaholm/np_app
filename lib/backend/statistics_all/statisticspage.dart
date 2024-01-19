import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../tasks(all)/widgets/filters/filter_widget.dart';
import 'stats_widgets.dart';

class Stats extends HookConsumerWidget {
  const Stats({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      'Progress made',
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
                const StatsDropDownOptions(),
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
          ],
        ),
      ),
    );
  }
}
