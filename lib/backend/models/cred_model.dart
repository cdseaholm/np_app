// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CredModel {
  String? docID;
  final String email;
  final String firstName;
  final String lastName;

  CredModel({
    this.docID,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docID': docID,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  factory CredModel.fromMap(Map<String, dynamic> map) {
    return CredModel(
      docID: map['docID'] != null ? map['docID'] as String : null,
      email: map['email'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
    );
  }

  factory CredModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    return CredModel(
        docID: doc.id,
        email: doc['email'],
        firstName: doc['firstName'],
        lastName: doc['lastName']);
  }
  factory CredModel.fromUser(User user) {
    return CredModel(
      docID: user.uid, // Extract the userID from the User object
      email: user.email ?? '',
      firstName: '',
      lastName: '',
    );
  }
}
