import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../backend/botnavbar.dart';
import 'calendarpage.dart';
import 'communitypage.dart';
import 'goalspage.dart';
import 'logged_out_homepage.dart';
import 'statisticspage.dart';

class LoggedInHomePage extends StatefulWidget {
  const LoggedInHomePage({super.key});

  @override
  State<LoggedInHomePage> createState() => _LoggedInHomePageState();
}

class _LoggedInHomePageState extends State<LoggedInHomePage> {
  late int _currentIndex;
  late ValueChanged<int> onTappedbar;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
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
                  Center(
                    child: Text(
                      'Home Page',
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ),
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
}

Widget _loggedInHomeUI(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height / 12,
    decoration: const BoxDecoration(
      color: Color.fromARGB(200, 5, 53, 20),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(
          'assets/Images/nplogo.png',
          fit: BoxFit.contain,
          width: 40,
          height: 40,
        ),
        const Flexible(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "[User's Name] Progress",
                style: TextStyle(fontSize: 14.0),
              ),
            ),
          ),
        ),
        PopupMenuButton<String>(
            icon: const Icon(Icons.settings),
            onSelected: (String value) {
              if (value == 'logout') {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoggedOutHomePage(),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoggedOutHomePage(),
                        ),
                      );
                    },
                    child: const Text('Logout'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'close',
                  child: Text('close'),
                )
              ];
            }),
      ],
    ),
  );
}
