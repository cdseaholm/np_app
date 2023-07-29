import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:np_app/backend/auth_pages/allthings_login/auth_checker_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NewProgress',
      theme: ThemeData(
        primaryColor: Colors.black,
        hintColor: const Color.fromARGB(176, 5, 53, 20),
      ),
      home: const AuthChecker(),
      debugShowCheckedModeBanner: false,
    );
  }
}
