import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../tasks(all)/taskmodels/task_model.dart';

class CalendarServices {
  final users = FirebaseFirestore.instance.collection('users');

  // CRUD

  // CREATE

  // READ

  // UPDATE

  Future<void> updateCalendarViewPreference(CalendarView preferredView) async {
    final user = FirebaseAuth.instance.currentUser;
    final userID = user?.uid;

    if (userID != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(userID);
      await userDoc
          .update({'calendarViewPreference': preferredView.toString()});
    }
  }

  //DELETE
}

DateTime formatDateTime(TaskModel task) {
  final format = DateFormat.yMEd();
  final outputFormat = DateFormat('MM/dd/yyyy');
  final parsedDate = format.parse(task.dateTask);

  final formattedDate = outputFormat.format(parsedDate);
  final date = DateFormat('MM/dd/yyyy').parse(formattedDate);
  final time = DateFormat('hh:mm a').parse(task.timeTask);
  final DateTime dateTime =
      date.add(Duration(hours: time.hour, minutes: time.minute));

  return dateTime;
}
