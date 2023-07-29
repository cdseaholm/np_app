// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CredModel {
  String? userID;
  final String displayName;
  final String email;
  final String firstName;
  final String lastName;

  CredModel({
    this.userID,
    required this.displayName,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userID': userID,
      'display name': displayName,
      'email': email,
      'first name': firstName,
      'last name': lastName,
    };
  }

  factory CredModel.fromMap(Map<String, dynamic> map) {
    return CredModel(
      userID: map['userID'] != null ? map['userID'] as String : null,
      displayName: map['displayName'] as String,
      email: map['email'] as String,
      firstName: map['first name'] as String,
      lastName: map['last name'] as String,
    );
  }

  factory CredModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    return CredModel(
        userID: doc.id,
        displayName: doc['display name'],
        email: doc['email'],
        firstName: doc['first name'],
        lastName: doc['last name']);
  }
  factory CredModel.fromUser(User user) {
    return CredModel(
      userID: user.uid, // Extract the userID from the User object
      displayName: user.displayName ?? '',
      email: user.email ?? '',
      firstName: '',
      lastName: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CredModel.fromJson(String source) =>
      CredModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
