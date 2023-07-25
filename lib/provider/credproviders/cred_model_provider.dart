import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../backend/models/cred_model.dart';
import 'auth_provider.dart';

final credModelProvider = Provider<CredModel>((ref) {
  final user = ref.watch(authStateProvider);
  return user.maybeWhen(
    data: (user) {
      return user != null
          ? CredModel(
              docID: user.uid,
              email: user.email ?? '',
              firstName: user.displayName ?? '',
              lastName: '',
            )
          : CredModel(email: '', firstName: '', lastName: '');
    },
    orElse: () {
      return CredModel(email: '', firstName: '', lastName: '');
    },
  );
});
