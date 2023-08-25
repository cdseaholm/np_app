import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:np_app/backend/auth_pages/allthings_login/auth_page.dart';
import 'package:np_app/backend/tasks(all)/widgets/category_widget_all/category_edit.dart';
import 'package:np_app/backend/tasks(all)/widgets/category_widget_all/category_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'NewProgress',
      theme: ThemeData(
        primaryColor: Colors.black,
        hintColor: const Color.fromARGB(176, 5, 53, 20),
      ),
      home: const AuthPage(),
      routes: {
        'editCategory1': (context) => const EditCategoryDialogContent(),
        'catWidget1': (context) => const SelectCategoryMethod()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
