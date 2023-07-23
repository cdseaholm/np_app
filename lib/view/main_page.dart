import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'logged_in_homepage.dart';
import 'logged_out_homepage.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const LoggedInHomePage();
          } else {
            return const LoggedOutHomePage();
          }
        });
  }
}
