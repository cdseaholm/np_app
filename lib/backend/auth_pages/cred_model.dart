// ignore_for_file: public_member_api_docs, sort_constructors_first, recursive_getters
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CredModel {
  String? userID;
  final String displayName;
  final String email;
  final String firstName;
  final String lastName;
  String? fullName;
  String? customUsername;

  CredModel({
    this.userID,
    required this.displayName,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.fullName,
    this.customUsername,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userID': userID,
      'display name': displayName,
      'email': email,
      'first name': firstName,
      'last name': lastName,
      'full name': firstName + lastName,
      'custom username': customUsername
    };
  }

  factory CredModel.fromMap(Map<String, dynamic> map) {
    return CredModel(
      userID: map['userID'] != null ? map['userID'] as String : null,
      displayName: map['display name'] as String,
      email: map['email'] as String,
      firstName: map['first name'] as String,
      lastName: map['last name'] as String,
      fullName: map['full name'] as String,
      customUsername: map['custom username'] as String,
    );
  }

  factory CredModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    return CredModel(
      userID: doc.id,
      displayName: doc['display name'],
      email: doc['email'],
      firstName: doc['first name'],
      lastName: doc['last name'],
      fullName: doc['first name'] + doc['last name'],
      customUsername: doc['custom username'],
    );
  }

  factory CredModel.fromUser(User user) {
    return CredModel(
      userID: user.uid, // Extract the userID from the User object
      displayName: user.displayName ?? '',
      email: user.email ?? '',
      firstName: '',
      lastName: '',
      fullName: '',
      customUsername: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CredModel.fromJson(String source) =>
      CredModel.fromMap(json.decode(source) as Map<String, dynamic>);

  CredModel copyWith({
    String? userID,
    String? displayName,
    String? email,
    String? firstName,
    String? lastName,
    String? fullName,
    String? customUsername,
  }) {
    return CredModel(
      userID: userID ?? this.userID,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      customUsername: customUsername ?? this.customUsername,
    );
  }

  void updateCustomUsername(String userID, String trim) {}

  void updateDisplayName(String userID, String s) {}
}
