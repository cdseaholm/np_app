import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FilterService {
  final users = FirebaseFirestore.instance.collection('users');

  // CRUD

  // CREATE

  // READ

  // UPDATE

  Future<void> updateFilter(WidgetRef ref, String filterView) async {
    final user = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .update({'filterView': filterView});
  }

  //DELETE
}

final filterProvider = StreamProvider<String>((ref) {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return const Stream.empty();
  }

  final filterStream = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((snapshot) {
    return snapshot.data()?['filterView'] as String;
  });

  return filterStream;
});

final categoryFilterProvider = StreamProvider<String>((ref) {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return const Stream.empty();
  }

  final categoryFilterStream = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((snapshot) {
    return snapshot.data()?['categoryFilter'] as String;
  });

  return categoryFilterStream;
});
