import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../tasks(all)/edit_task.dart';
import '../tasks(all)/provider/taskproviders/task_providers.dart';

import '../tasks(all)/taskmodels/task_model.dart';
import 'calendar_model.dart';
import 'calendar_services.dart';
import 'calendar_widgets.dart';

class Calendar extends ConsumerStatefulWidget {
  const Calendar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CalendarState();
}

class _CalendarState extends ConsumerState<Calendar> {
  final CalendarController _controller = CalendarController();
  CalendarTaskDataSource? calendarTasks;
  List<TaskModel>? fullTasks;
  bool isInitialLoaded = false;

  List<CalendarTask> taskDetails = <CalendarTask>[];
  List<TaskModel> taskModelDetails = <TaskModel>[];

  @override
  void initState() {
    super.initState();
    _controller;
    getDataFromDatabase().then((results) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
          Expanded(
            child: SfCalendar(
              view: CalendarView.month,
              controller: _controller,
              showNavigationArrow: true,
              cellEndPadding: 5,
              cellBorderColor: Colors.black,
              allowedViews: const [
                CalendarView.day,
                CalendarView.week,
                CalendarView.month,
                CalendarView.schedule,
              ],
              todayTextStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              showTodayButton: true,
              showDatePickerButton: true,
              showCurrentTimeIndicator: true,
              dataSource: calendarTasks,
              timeSlotViewSettings: TimeSlotViewSettings(
                  timeTextStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  minimumAppointmentDuration: const Duration(minutes: 5),
                  timeIntervalHeight: MediaQuery.of(context).size.height / 10),
              monthViewSettings: MonthViewSettings(
                  agendaViewHeight: MediaQuery.of(context).size.height / 4,
                  numberOfWeeksInView: 6,
                  navigationDirection: MonthNavigationDirection.horizontal,
                  showAgenda: false,
                  monthCellStyle: const MonthCellStyle(
                      trailingDatesTextStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey),
                      leadingDatesTextStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey))),
              onTap: (calendarTapDetails) {
                calendarTapped(calendarTapDetails);
                if (kDebugMode) {
                  print(calendarTapDetails);
                }
                if (kDebugMode) {
                  print("Appointments: ${calendarTapDetails.appointments}");
                  print("taskDetails length: ${taskDetails.length}");
                }
              },
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height / 4,
              decoration: const BoxDecoration(color: Colors.white),
              child: ListView.separated(
                itemCount: taskDetails.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      padding: const EdgeInsets.all(2),
                      height: 60,
                      color: taskDetails[index].background,
                      child: ListTile(
                          leading: Column(
                            children: <Widget>[
                              Text(
                                taskDetails[index].from.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  height: 1.7,
                                ),
                              ),
                            ],
                          ),
                          title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  taskDetails[index].eventName!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ]),
                          trailing: ElevatedButton(
                            onPressed: () async {
                              updateProviders(taskModelDetails[index], ref);

                              await showModalBottomSheet(
                                showDragHandle: true,
                                isDismissible: false,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                context: context,
                                builder: (context) => EditTaskModel(
                                  taskToUpdate: taskModelDetails[index],
                                  onTaskUpdated: (task) {
                                    setState(() {
                                      taskModelDetails[index] = task;
                                    });
                                  },
                                ),
                              );
                            },
                            child: const Text('Edit Task'),
                          )));
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  height: 5,
                ),
              ),
            ),
          ),
        ]),
        floatingActionButton: const CalendarTaskButton());
  }

  Future<void> getDataFromDatabase() async {
    final taskList = ref.read(taskListProvider);

    if (taskList.isNotEmpty) {
      List<CalendarTask> calendarTaskList = taskList
          .map((task) => CalendarTask(
              eventName: task.taskTitle,
              from: formatDateTime(task),
              to: formatDateTime(task).add(const Duration(minutes: 30)),
              background: colorFromHex(task.categoryColorHex),
              isAllDay: false,
              key: task.docID,
              reoccurance: task.repeatingFrequency))
          .toList();
      setState(() {
        calendarTasks = CalendarTaskDataSource(calendarTaskList);
      });
      setState(() {
        fullTasks = taskList
            .map((task) => TaskModel(
                taskTitle: task.taskTitle,
                description: task.description,
                categoryID: task.categoryID,
                categoryName: task.categoryName,
                categoryColorHex: task.categoryColorHex,
                dateTask: task.dateTask,
                timeTask: task.timeTask,
                isDone: task.isDone,
                repeatShown: task.repeatShown,
                repeatingDays: task.repeatingDays,
                repeatingFrequency: task.repeatingFrequency,
                stopDate: task.stopDate,
                creationDate: task.creationDate,
                status: task.status))
            .toList();
      });
    }
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (_controller.view == CalendarView.month &&
        calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      final selectedDate = calendarTapDetails.date;
      final filteredTasks = taskModelDetails.where((task) {
        final taskDate = DateTime.parse(task.dateTask);
        return taskDate.year == selectedDate!.year &&
            taskDate.month == selectedDate.month &&
            taskDate.day == selectedDate.day;
      }).toList();

      final filteredCalendarTasks = taskDetails
          .where((calendarTask) =>
              filteredTasks.any((task) => task.docID == calendarTask.key))
          .toList();

      setState(() {
        taskDetails = filteredCalendarTasks;
      });
      if (kDebugMode) {
        print(taskDetails);
      }
    } else if ((_controller.view == CalendarView.week ||
            _controller.view == CalendarView.workWeek) &&
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {}
  }
}
