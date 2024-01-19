import 'package:intl/intl.dart';

String determineTaskStatus(String dateTask) {
  final currentDate = DateTime.now();
  final taskDate = DateFormat.yMEd().parse(dateTask);

  if (dateTask == 'mm/dd/yy') {
    return '';
  } else if (currentDate.isBefore(taskDate)) {
    return 'Upcoming';
  } else if (currentDate.day == taskDate.day &&
      currentDate.month == taskDate.month &&
      currentDate.year == taskDate.year) {
    return 'Due Today';
  } else if (currentDate.isAfter(taskDate)) {
    return 'Overdue';
  } else {
    return '';
  }
}
