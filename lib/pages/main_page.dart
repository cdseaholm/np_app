import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:np_app/pages/logged_in_homepage.dart';
import 'package:np_app/pages/logged_out_homepage.dart';

class MainPaige extends StatelessWidget {
  const MainPaige({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return const LoggedInHomePage();
          } else {
            return const LoggedOutHomePage();
          }
        },
      ),
    );
  }
}
