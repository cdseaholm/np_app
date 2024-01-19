import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:np_app/backend/auth_pages/allthings_login/auth_page.dart';
import 'package:np_app/backend/tasks(all)/widgets/category_widget_all/category_edit.dart';
import 'package:np_app/backend/tasks(all)/widgets/category_widget_all/category_widget.dart';
import 'package:np_app/frontend/logged_in_homepage.dart';

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
        'catWidget1': (context) => const SelectCategoryMethod(),
        'LoggedInHomePage1': (context) => const LoggedInHomePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

enum PreviousPage { newTask, editTask }

/*

List<DateTime> dates = [
  DateTime(1990, 1, 1),
  DateTime(1991, 1, 1),
  DateTime(1223, 2, 1),
  DateTime(2013, 1, 3),
  DateTime(2023, 4, 5),
  DateTime(2024, 6, 7),
  DateTime(2025, 1, 24)
];

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort the list of dates by upcoming
    final sortedDates = sortByUpcoming(dates);
    final sortedDatesTwo = sortByOverdue(dates);

    return MaterialApp(
      title: 'NewProgress',
      theme: ThemeData(
        primaryColor: Colors.black,
        hintColor: const Color.fromARGB(176, 5, 53, 20),
      ),
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                  child: Column(
                children: sortedDates
                    .map((date) => Text(date.toLocal().toString()))
                    .toList(),
              )),
              const Gap(20),
              SizedBox(
                  child: Column(
                children: sortedDatesTwo
                    .map((date) => Text(date.toLocal().toString()))
                    .toList(),
              ))
            ]),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  List<DateTime> sortByOverdue(List<DateTime> dates) {
    final today = DateTime.now();
    final upcomingDates = dates.where((date) => date.isBefore(today)).toList();
    upcomingDates.sort((a, b) => a.compareTo(b));
    return upcomingDates;
  }

  List<DateTime> sortByUpcoming(List<DateTime> dates) {
    final today = DateTime.now();

    final upcomingDates = dates.where((date) => date.isAfter(today)).toList();

    upcomingDates.sort((a, b) => a.compareTo(b));

    return upcomingDates;
  }
}
*/