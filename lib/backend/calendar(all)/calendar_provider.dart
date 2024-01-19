import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../tasks(all)/provider/taskproviders/task_providers.dart';

Stream<Future<CalendarDataSource<Object?>>> fetchData(WidgetRef ref) async* {
  final format = DateFormat.yMEd();
  final timeFormat = DateFormat('hh:mm a');
  final taskList = ref.watch(taskListProvider);

  List<Appointment> tasks = <Appointment>[];

  for (var task in taskList) {
    var taskReoccurance = 'Never';
    if (task.repeatingDays.isEmpty && task.repeatingFrequency == 'Daily') {
      taskReoccurance = 'FREQ=DAILY';
    }
    if (task.repeatingDays.isEmpty && task.repeatingFrequency == 'Weekly') {
      taskReoccurance = 'FREQ=WEEKLY';
    }
    if (task.repeatingDays.isEmpty && task.repeatingFrequency == 'Monthly') {
      taskReoccurance = 'FREQ=MONTHLY';
    }
    if (task.repeatingDays.isEmpty && task.repeatingFrequency == 'Yearly') {
      taskReoccurance = 'FREQ=YEARLY';
    }
    final parsedDate = format.parse(task.dateTask);
    final parsedTime = timeFormat.parse(task.timeTask);
    final dateTimeWithTime = parsedDate.add(Duration(
      hours: parsedTime.hour,
      minutes: parsedTime.minute,
    ));

    final Appointment onceTask = Appointment(
        startTime: dateTimeWithTime,
        endTime: dateTimeWithTime.add(const Duration(minutes: 30)),
        isAllDay: false,
        subject: task.taskTitle,
        color: colorFromHex(task.categoryColorHex)!,
        startTimeZone: null,
        endTimeZone: null,
        id: task.docID);

    tasks.add(onceTask);

    final Appointment reoccuringTask = Appointment(
        startTime: dateTimeWithTime,
        recurrenceRule: taskReoccurance,
        endTime: dateTimeWithTime.add(const Duration(minutes: 30)),
        isAllDay: false,
        subject: task.taskTitle,
        color: colorFromHex(task.categoryColorHex)!,
        startTimeZone: null,
        endTimeZone: null,
        id: task.docID);

    tasks.add(reoccuringTask);
  }
  yield* fetchData(ref);
}
