import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:np_app/backend/tasks(all)/provider/taskproviders/service_provider.dart';
import 'package:np_app/backend/tasks(all)/repeat/repeat_sections.dart';
import '../../../main.dart';
import '../taskmodels/task_model.dart';
import '../widgets/constants/constants.dart';
import 'repeat_format.dart';
import 'repeat_notifiers.dart';

class RepeatingWidget extends ConsumerStatefulWidget {
  const RepeatingWidget({
    required this.previousPage,
    required this.task,
    Key? key,
  }) : super(key: key);

  final PreviousPage previousPage;
  final TaskModel task;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RepeatingWidgetState();
}

class _RepeatingWidgetState extends ConsumerState<RepeatingWidget> {
  String selectedRepeatOption = '';
  int daysNum = 0;
  final format = DateFormat.yMd();

  @override
  void initState() {
    super.initState();
    if (widget.previousPage == PreviousPage.editTask &&
        widget.task.repeatingDays.isNotEmpty) {
      selectedRepeatingDaysList = ref.read(repeatingOptionDays);
      showDaysHint = false;
      selectedDaysNotifier.value = widget.task.repeatingDays;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Should this repeat?',
            style: AppStyle.headingTwo,
          ),
          const Gap(6),
          Material(
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: .5),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  setState(() {
                    if (widget.previousPage == PreviousPage.editTask) {
                      if (widget.task.repeatingFrequency != 'No' &&
                          selectedRepeatingDaysList.isEmpty) {
                        frequencyNotifier.value =
                            widget.task.repeatingFrequency;
                        showDaysHint = true;
                      }
                      if (widget.task.repeatingDays.isNotEmpty &&
                          selectedRepeatingDaysList.isNotEmpty) {
                        selectedRepeatingDaysList = widget.task.repeatingDays;
                        showDaysHint = false;
                      }

                      if (widget.task.stopDate != 'Until?') {
                        repeatUntilNotifier.value = widget.task.stopDate;
                      }
                    }
                  });
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Repeat Selection',
                                style: RepeatShownStyle.inAlertShown,
                              )
                            ]),
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const RepeatCheckBoxFrequency(),
                                  RepeatDropDownFrequency(
                                    onFrequencyChanged: (newFrequency) {
                                      setState(() {
                                        frequencyNotifier.value = newFrequency;
                                        selectedDaysNotifier.value = [];
                                        selectedRepeatingDaysList.clear();
                                        showDaysHint = true;

                                        ref
                                            .read(repeatingOptionFrequency
                                                .notifier)
                                            .update((state) => newFrequency);
                                        ref
                                            .read(repeatingOptionDays.notifier)
                                            .update((state) => []);
                                      });
                                    },
                                  )
                                ],
                              ),
                              const Gap(5),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '- OR -',
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                              const Gap(5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const RepeatCheckBoxDays(),
                                  RepeatMultiSelect(onMultiSelectionChanged:
                                      (newSelectedDays) {
                                    setState(() {
                                      frequencyNotifier.value = 'No';
                                      selectedRepeatingDaysList =
                                          newSelectedDays;
                                      selectedDaysNotifier.value =
                                          newSelectedDays;
                                      showDaysHint = false;
                                      ref
                                          .read(
                                              repeatingOptionFrequency.notifier)
                                          .update((state) => 'No');
                                      ref
                                          .read(repeatingOptionDays.notifier)
                                          .update((state) => newSelectedDays);
                                    });
                                  }, onNoMultiSelection: (noSelectedDays) {
                                    setState(() {
                                      selectedRepeatingDaysList = [];
                                      selectedDaysNotifier.value = [];
                                      showDaysHint = true;
                                      ref
                                          .read(repeatingOptionDays.notifier)
                                          .update((state) => []);
                                    });
                                  }),
                                ],
                              ),
                              const Gap(5),
                              const Divider(
                                indent: 40,
                                endIndent: 40,
                                thickness: 2,
                                color: Colors.black38,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(children: [
                                    const Text('Optional: Stop Date'),
                                    const Gap(5),
                                    Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black38),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: const RepeatDateTime(),
                                    ),
                                    const Gap(5),
                                    Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4.5,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                23,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black38),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Center(
                                          child: ElevatedButton(
                                            style: const ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        Color.fromARGB(255, 123,
                                                            213, 255))),
                                            child: const Center(
                                                child: Text(
                                              'Clear Date',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            )),
                                            onPressed: () {
                                              setState(() {
                                                ref
                                                    .read(stopDateProvider
                                                        .notifier)
                                                    .update(
                                                        (state) => 'Until?');
                                                repeatUntilNotifier.value =
                                                    'Until?';
                                                if (frequencyNotifier.value !=
                                                        'No' &&
                                                    selectedDaysNotifier
                                                        .value.isEmpty) {
                                                  ref
                                                      .read(repeatShownProvider
                                                          .notifier)
                                                      .update((state) =>
                                                          frequencyNotifier
                                                              .value);
                                                } else if (frequencyNotifier
                                                            .value ==
                                                        'No' &&
                                                    selectedDaysNotifier
                                                        .value.isNotEmpty) {
                                                  ref
                                                      .read(repeatShownProvider
                                                          .notifier)
                                                      .update((state) =>
                                                          repeatFormat(
                                                              selectedDaysNotifier
                                                                  .value));
                                                }
                                              });
                                            },
                                          ),
                                        )),
                                  ]),
                                ],
                              ),
                              const Divider(
                                  thickness: 2,
                                  color: Colors.black38,
                                  indent: 40,
                                  endIndent: 40),
                              const Gap(10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            if (widget.previousPage ==
                                                PreviousPage.newTask) {
                                              ref
                                                  .read(repeatingOptionFrequency
                                                      .notifier)
                                                  .update((state) => 'No');
                                              ref
                                                  .read(repeatingOptionDays
                                                      .notifier)
                                                  .update((state) => []);
                                            } else if (widget.previousPage ==
                                                PreviousPage.editTask) {
                                              ref
                                                  .read(repeatingOptionFrequency
                                                      .notifier)
                                                  .update((state) => widget
                                                      .task.repeatingFrequency);
                                              ref
                                                  .read(repeatingOptionDays
                                                      .notifier)
                                                  .update((state) => widget
                                                      .task.repeatingDays);

                                              ref
                                                  .read(
                                                      stopDateProvider.notifier)
                                                  .update((state) =>
                                                      widget.task.stopDate);
                                              ref
                                                  .read(repeatShownProvider
                                                      .notifier)
                                                  .update((state) =>
                                                      widget.task.repeatShown);
                                            }

                                            Navigator.of(context).pop();
                                          });
                                        },
                                        child: const Text('Cancel')),
                                    ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          await updateRepeatProviders(
                                              repeatUntilNotifier.value,
                                              repeatUntilNotifier.value,
                                              ref);
                                        } finally {
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: const Text('Done'),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          )
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.arrow_counterclockwise),
                      const SizedBox(width: 6),
                      Consumer(builder: (context, ref, child) {
                        late final repeatShown = ref.watch(repeatShownProvider);
                        late final stopDate = ref.watch(stopDateProvider);

                        if (stopDate != 'Until?' && repeatShown != 'No') {
                          final textLines = repeatShown.split(' until ');

                          if (textLines.length == 2) {
                            return Column(
                              children: [
                                Text(textLines[0],
                                    style: const TextStyle(fontSize: 12)),
                                Text(textLines[1],
                                    style: const TextStyle(fontSize: 12)),
                              ],
                            );
                          } else {
                            // Handle the case where the split didn't produce two parts
                            return Text(repeatShown,
                                style: const TextStyle(fontSize: 12));
                          }
                        } else {
                          ref
                              .read(repeatShownProvider.notifier)
                              .update((state) => repeatShown);
                          return Wrap(
                            children: [
                              Text(repeatShown,
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          );
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
