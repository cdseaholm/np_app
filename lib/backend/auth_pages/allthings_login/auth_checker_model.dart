import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_app/backend/auth_pages/auth_provider.dart';
import 'package:np_app/view/main_user_views/logged_in_homepage.dart';
import 'package:np_app/view/main_user_views/logged_out_homepage.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _authState = ref.watch(authStateProvider);

    if (kDebugMode) {
      print('authState: $_authState');
    }

    return _authState.when(data: (user) {
      if (user != null) return const LoggedInHomePage();
      return const LoggedOutHomePage();
    }, loading: () {
      if (kDebugMode) {
        print('Authentication state: Loading');
      }
      return const SplashScreen();
    }, error: (e, trace) {
      if (kDebugMode) {
        print('Authentication state: Error');
      }
      return const LoggedOutHomePage();
    });
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
