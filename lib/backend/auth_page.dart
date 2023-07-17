import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:np_app/pages/logged_in_homepage.dart';
import 'package:np_app/pages/logged_out_homepage.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  //show loggedoutpage unless loggedin
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoggedInUser();
  }

  Future<void> checkLoggedInUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  void toggleLoggedIn(bool value) {
    setState(() {
      isLoggedIn = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      return LoggedOutHomePage(
        onLoginOptionSelected: toggleLoggedIn,
      );
    } else {
      return const LoggedInHomePage();
    }
  }
}
