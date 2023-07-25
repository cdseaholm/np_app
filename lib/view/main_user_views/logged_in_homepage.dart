import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../backend/widget/botnavbar_widget.dart';
import '../../services/sign_out_service.dart';
import 'viewdataplugs/task.dart';
import 'calendarpage.dart';
import 'communitypage.dart';
import 'goalspage.dart';
import 'statisticspage.dart';

class LoggedInHomePage extends StatefulWidget {
  const LoggedInHomePage({Key? key}) : super(key: key);

  @override
  State<LoggedInHomePage> createState() => _LoggedInHomePageState();
}

class _LoggedInHomePageState extends State<LoggedInHomePage> {
  late int _currentIndex;
  late ValueChanged<int> onTappedbar;
  late PageController _pageController;
  final user = FirebaseAuth.instance.currentUser!;
  String userDisplayName = '';
  StreamSubscription<User?>? _authStateChangesListener;

  List<String> docIDs = [];

  Future getDocId() async {
    await FirebaseFirestore.instance.collection('users').get().then(
          // ignore: avoid_function_literals_in_foreach_calls
          (snapshot) => snapshot.docs.forEach((document) {
            // ignore: avoid_print
            print(document.reference);
            docIDs.add(document.reference.id);
          }),
        );
  }

  @override
  void initState() {
    super.initState();
    getDocId();
    _authStateChangesListener =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          userDisplayName = user.displayName ?? '';
        });
      } else {
        setState(() {
          userDisplayName = 'Your Progress';
        });
      }
    });
    _currentIndex = 0;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _authStateChangesListener?.cancel();
    _pageController
        .dispose(); // Dispose the _pageController when no longer needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            _loggedInHomeUI(context),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: const [
                  Center(child: SafeArea(child: Tasks())),
                  Calendar(),
                  Stats(),
                  Community(),
                  Goals(),
                ],
              ),
            ),
            MyBottomNavigationBar(
                currentIndex: _currentIndex,
                onTappedbar: (index) {
                  setState(() {
                    _currentIndex = index;
                    _pageController.jumpToPage(index);
                  });
                }),
          ],
        ),
      ),
    );
  }

  Widget _loggedInHomeUI(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 12,
        decoration: const BoxDecoration(),
        child: Scaffold(
          appBar: AppBar(
              toolbarHeight: MediaQuery.of(context).size.height / 12,
              backgroundColor: const Color.fromARGB(255, 76, 119, 85),
              elevation: 0,
              title: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  radius: 25,
                  child: Text(
                    'NP',
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                  ),
                ),
                title: Text(
                  "$userDisplayName's Progress",
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.bell),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.settings),
                        onSelected: (String value) {},
                        itemBuilder: (BuildContext context) {
                          return <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              child: GestureDetector(
                                onTap: () => AuthSignOut().signOut(context),
                                child: const Text('Logout'),
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'close',
                              child: Text('close'),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                ),
              ]),
        ));
  }
}
