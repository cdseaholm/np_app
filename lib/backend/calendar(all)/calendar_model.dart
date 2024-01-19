import 'dart:ui';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../tasks(all)/taskmodels/task_model.dart';

class CalendarTaskDataSource extends CalendarDataSource {
  CalendarTaskDataSource(List<CalendarTask> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from!;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to!;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName!;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background!;
  }

  // Add other necessary methods and properties as needed

  int getAppointmentCount() {
    return appointments!.length;
  }
}

class CalendarTask {
  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;
  String? key;
  String? reoccurance;

  CalendarTask(
      {this.eventName,
      this.from,
      this.to,
      this.background,
      this.isAllDay,
      this.key,
      this.reoccurance});

  static CalendarTask fromFireBaseSnapShotData(TaskModel task, WidgetRef ref) {
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

    return CalendarTask(
        eventName: task.taskTitle,
        from: DateFormat('dd/MM/yyyy HH:mm:ss')
            .parse('${task.dateTask} ${task.timeTask}'),
        to: DateFormat('dd/MM/yyyy HH:mm:ss')
            .parse('${task.dateTask} ${task.timeTask}')
            .add(const Duration(minutes: 15)),
        background: colorFromHex(task.categoryColorHex),
        isAllDay: false,
        key: task.docID,
        reoccurance: taskReoccurance);
  }
}
