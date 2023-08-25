// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final toDoModelProvider = StateProvider<TaskModel>((ref) {
  return TaskModel(
    taskTitle: '',
    description: '',
    categoryID: '',
    categoryName: '',
    categoryColorHex: '',
    dateTask: '',
    timeTask: '',
    isDone: false,
  );
});

class TaskModel {
  final String docID;
  final String taskTitle;
  final String description;
  late String categoryID;
  final String categoryName;
  final String categoryColorHex;
  final String dateTask;
  final String timeTask;
  final bool isDone;

  TaskModel({
    this.docID = '',
    required this.taskTitle,
    required this.description,
    required this.categoryID,
    required this.categoryName,
    required this.categoryColorHex,
    required this.dateTask,
    required this.timeTask,
    required this.isDone,
  });

  TaskModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> doc)
      : docID = doc.id,
        taskTitle = doc['taskTitle'],
        description = doc['description'],
        categoryID = doc['categoryID'],
        categoryName = doc['categoryName'],
        categoryColorHex = doc['categoryColorHex'],
        dateTask = doc['dateTask'],
        timeTask = doc['timeTask'],
        isDone = doc['isDone'];

  TaskModel.fromJson(Map<String, dynamic> json)
      : docID = json['docID'] as String,
        taskTitle = json['taskTitle'] as String,
        description = json['description'] as String,
        categoryID = json['categoryID'] as String,
        categoryName = json['categoryName'] as String,
        categoryColorHex = json['categoryColorHex'] as String,
        dateTask = json['dateTask'] as String,
        timeTask = json['timeTask'] as String,
        isDone = json['isDone'] as bool;

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
      };
}
