import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppStyle {
  static const headingOne =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black);

  static const headingTwo =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black);
}

String formatTaskDate(String date) {
  final taskDate = DateFormat.yMEd().parse(date);
  final currentDate = DateTime.now();
  final difference = taskDate.difference(currentDate).inDays;

  if (difference <= 60) {
    return DateFormat.MEd().format(taskDate);
  } else {
    return DateFormat.yMd().format(taskDate);
  }
}

class RepeatShownStyle {
  static const inAlertShown = TextStyle(
      fontSize: 22,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.bold);
}
