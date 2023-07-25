import 'package:cloud_firestore/cloud_firestore.dart';

import '../backend/models/cred_model.dart';

class CredService {
  final users = FirebaseFirestore.instance.collection('users');

  // CRUD

  // CREATE
  void addUserDetails(CredModel model) {
    users.add(model.toMap());
  }
}
