// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:np_app/backend/models/cred_model.dart';

class ToDoModel {
  String? docID;
  final String titleTask;
  final String description;
  final String category;
  final String dateTask;
  final String timeTask;
  final CredModel credModel;

  ToDoModel({
    this.docID,
    required this.titleTask,
    required this.description,
    required this.category,
    required this.dateTask,
    required this.timeTask,
    required this.credModel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docID': docID,
      'titleTask': titleTask,
      'description': description,
      'category': category,
      'dateTask': dateTask,
      'timeTask': timeTask,
      'userId': credModel.docID,
    };
  }

  factory ToDoModel.fromMap(Map<String, dynamic> map) {
    return ToDoModel(
        docID: map['docID'] != null ? map['docID'] as String : null,
        titleTask: map['titleTask'] as String,
        description: map['description'] as String,
        category: map['category'] as String,
        dateTask: map['dateTask'] as String,
        timeTask: map['timeTask'] as String,
        credModel: CredModel(
          docID: map['userId'],
          email: '',
          firstName: '',
          lastName: '',
        ));
  }

  factory ToDoModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ToDoModel(
      docID: doc.id,
      titleTask: doc['titleTask'],
      description: doc['decription'],
      category: doc['category'],
      dateTask: doc['dateTask'],
      timeTask: doc['timeTask'],
      credModel: CredModel(
        docID: doc['userId'], // Get the user ID from the document
        email: '', // You can set these to empty strings or default values
        firstName: '',
        lastName: '',
      ),
    );
  }
}
