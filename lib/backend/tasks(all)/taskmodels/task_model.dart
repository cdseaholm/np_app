// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  late String docID;
  late String taskTitle;
  late String description;
  final String categoryID;
  final String categoryName;
  final String categoryColorHex;
  late String dateTask;
  late String timeTask;
  late bool isDone;
  late String repeatShown;
  late List<String> repeatingDays;
  late String repeatingFrequency;
  late String stopDate;
  final String creationDate;
  final String status;

  TaskModel({
    String? docID,
    required this.taskTitle,
    required this.description,
    required this.categoryID,
    required this.categoryName,
    required this.categoryColorHex,
    required this.dateTask,
    required this.timeTask,
    required this.isDone,
    required this.repeatShown,
    required this.repeatingDays,
    required this.repeatingFrequency,
    required this.stopDate,
    required this.creationDate,
    required this.status,
  }) : docID = docID ?? '';

  TaskModel copyWith(
      {String? docID,
      String? taskTitle,
      String? description,
      String? categoryID,
      String? categoryName,
      String? categoryColorHex,
      String? dateTask,
      String? timeTask,
      bool? isDone,
      String? repeatShown,
      List<String>? repeatingDays,
      String? repeatingFrequency,
      String? stopDate,
      String? creationDate,
      String? status}) {
    return TaskModel(
        docID: docID ?? this.docID,
        taskTitle: taskTitle ?? this.taskTitle,
        description: description ?? this.description,
        categoryID: categoryID ?? this.categoryID,
        categoryName: categoryName ?? this.categoryName,
        categoryColorHex: categoryColorHex ?? this.categoryColorHex,
        dateTask: dateTask ?? this.dateTask,
        timeTask: timeTask ?? this.timeTask,
        isDone: isDone ?? this.isDone,
        repeatShown: repeatShown ?? this.repeatShown,
        repeatingDays: repeatingDays ?? this.repeatingDays,
        repeatingFrequency: repeatingFrequency ?? this.repeatingFrequency,
        stopDate: stopDate ?? this.stopDate,
        creationDate: creationDate ?? this.creationDate,
        status: status ?? this.status);
  }

  TaskModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> doc)
      : docID = doc.id,
        taskTitle = doc['taskTitle'],
        description = doc['description'],
        categoryID = doc['categoryID'],
        categoryName = doc['categoryName'],
        categoryColorHex = doc['categoryColorHex'],
        dateTask = doc['dateTask'],
        timeTask = doc['timeTask'],
        isDone = doc['isDone'],
        repeatShown = doc['repeatShown'],
        repeatingDays = doc['repeatingDays'],
        repeatingFrequency = doc['repeatingFrequency'],
        stopDate = doc['stopDate'],
        creationDate = doc['creationDate'],
        status = doc['status'];

  TaskModel.fromJson(Map<String, dynamic> json)
      : docID = json['docID'] as String,
        taskTitle = json['taskTitle'] as String,
        description = json['description'] as String,
        categoryID = json['categoryID'] as String,
        categoryName = json['categoryName'] as String,
        categoryColorHex = json['categoryColorHex'] as String,
        dateTask = json['dateTask'] as String,
        timeTask = json['timeTask'] as String,
        isDone = json['isDone'] as bool,
        repeatShown = json['repeatShown'] as String,
        repeatingDays = (json['repeatingDays'] as List<dynamic>).cast<String>(),
        repeatingFrequency = json['repeatingFrequency'] as String,
        stopDate = json['stopDate'] as String,
        creationDate = json['creationDate'] as String,
        status = json['status'] as String;

  Map<String, dynamic> toJson() => {
        'docID': docID,
        'taskTitle': taskTitle,
        'description': description,
        'categoryID': categoryID,
        'categoryName': categoryName,
        'categoryColorHex': categoryColorHex,
        'dateTask': dateTask,
        'timeTask': timeTask,
        'isDone': isDone,
        'repeatShown': repeatShown,
        'repeatingDays': repeatingDays,
        'repeatingFrequency': repeatingFrequency,
        'stopDate': stopDate,
        'creationDate': creationDate,
        'status': status
      };
}
