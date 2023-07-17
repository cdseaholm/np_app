import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:np_app/pages/logged_in_homepage.dart';
import 'package:np_app/pages/logged_out_homepage.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool remainSignedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginOption();
  }

  void checkLoginOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool savedLoginOption = prefs.getBool('Remain Signed In?') ?? false;
    setState(() {
      remainSignedIn = savedLoginOption;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            if (remainSignedIn) {
              return const LoggedInHomePage();
            } else {
              FirebaseAuth.instance.signOut();
              return LoggedOutHomePage(
                onLoginOptionSelected: (value) {
                  setState(() {
                    remainSignedIn = value;
                  });
                },
              );
            }
          } else {
            return LoggedOutHomePage(
              onLoginOptionSelected: (value) {
                setState(() {
                  remainSignedIn = value;
                });
              },
            );
          }
        },
      ),
    );
  }
}
