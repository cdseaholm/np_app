// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final toDoModelProvider = StateProvider<TaskModel>((ref) {
  return TaskModel(
      taskTitle: '',
      description: '',
      category: '',
      dateTask: '',
      timeTask: '',
      isDone: false);
});

class TaskModel {
  final String docID;
  final String taskTitle;
  final String description;
  final String category;
  final String dateTask;
  final String timeTask;
  final bool isDone;

  TaskModel({
    this.docID = '',
    required this.taskTitle,
    required this.description,
    required this.category,
    required this.dateTask,
    required this.timeTask,
    required this.isDone,
  });

  TaskModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> doc)
      : docID = doc.id,
        taskTitle = doc['taskTitle'],
        description = doc['description'],
        category = doc['category'],
        dateTask = doc['dateTask'],
        timeTask = doc['timeTask'],
        isDone = doc['isDone'];

  TaskModel.fromJson(Map<String, dynamic> json)
      : docID = json['docID'] as String,
        taskTitle = json['taskTitle'] as String,
        description = json['description'] as String,
        category = json['category'] as String,
        dateTask = json['dateTask'] as String,
        timeTask = json['timeTask'] as String,
        isDone = json['isDone'] as bool;

  Map<String, dynamic> toJson() => {
        'docID': docID,
        'taskTitle': taskTitle,
        'description': description,
        'category': category,
        'dateTask': dateTask,
        'timeTask': timeTask,
        'isDone': isDone,
      };
}
