import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../auth_pages/auth_provider.dart';
import '../auth_pages/cred_model.dart';
import 'profile_service.dart';

final profileServiceProvider = StateProvider<ProfileService>((ref) {
  return ProfileService();
});

final userFieldsProvider = StreamProvider.autoDispose<CredModel?>((ref) {
  final userID = ref.watch(authStateProvider).maybeWhen(
        data: (user) => user?.uid,
        orElse: () => null,
      );

  if (userID != null) {
    final getUserData = FirebaseFirestore.instance
        .doc('users/$userID')
        .snapshots()
        .map((snapshot) => CredModel.fromSnapshot(snapshot));

    final subscription = getUserData.listen((credModel) {
      // The credModel has been updated with new data
    });

    // Dispose the subscription when the provider is no longer used
    ref.onDispose(() => subscription.cancel());

    return getUserData;
  } else {
    return Stream.value(null);
  }
});
