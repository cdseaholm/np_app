import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:np_app/auth/forms/login.dart';
import 'package:np_app/auth/forms/user_regist.dart';
import 'package:np_app/pages/logged_in_homepage.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  //show loggedoutpage unless loggedin
  bool showLoginScreen = true;

  @override
  void initState() {
    super.initState();
    checkLoggedInUser();
  }

  Future<void> checkLoggedInUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        showLoginScreen = false;
      });
    }
  }

  void toggleScreens() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(
        onSignInSuccess: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoggedInHomePage()),
          );
        },
      );
    } else {
      return RegisterPage(showLoginScreen: toggleScreens);
    }
  }
}
