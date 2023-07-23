import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final CalendarController _controller = CalendarController();

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (_controller.view == CalendarView.month &&
        calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      _controller.view = CalendarView.day;
    } else if ((_controller.view == CalendarView.week ||
            _controller.view == CalendarView.workWeek) &&
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      _controller.view = CalendarView.day;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCalendar(
        showNavigationArrow: true,
        cellEndPadding: 5,
        cellBorderColor: Colors.blue,
        allowedViews: const [
          CalendarView.day,
          CalendarView.week,
          CalendarView.month,
        ],
        // dataSource: MeetingDataSource(_getDataSource()) <-add in later
        monthViewSettings: const MonthViewSettings(
            navigationDirection: MonthNavigationDirection.vertical),
        // appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),<-Add in later
      ),
    );
  }
}
