import 'package:flutter/material.dart';
import 'package:np_app/backend/firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:np_app/pages/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NewProgress',
      theme: ThemeData(
        primaryColor: Colors.black,
        hintColor: const Color.fromARGB(176, 5, 53, 20),
      ),
      home: const MainPaige(),
      debugShowCheckedModeBanner: false,
    );
  }
}
