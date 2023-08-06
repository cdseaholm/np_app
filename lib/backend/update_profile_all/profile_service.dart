import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  final users = FirebaseFirestore.instance.collection('users');

  // CRUD

  // CREATE

  // READ

  // UPDATE
  Future<void> updateDisplayName(
      String userID, String updatedDisplayName) async {
    await users.doc(userID).update({'display name': updatedDisplayName});
  }

  Future<void> updateCustomUsername(
      String userID, String updatedCustomUsername) async {
    await users.doc(userID).update({'custom username': updatedCustomUsername});

    final userSnapshot = await users.doc(userID).get();
    final displayName = userSnapshot.get('display name') as String?;
    if (displayName == null || displayName == updatedCustomUsername) {
      return;
    }
    await users.doc(userID).update({'display name': updatedCustomUsername});
  }
  //DELETE
}
