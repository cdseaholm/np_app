import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';

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
    decoration: BoxDecoration(
      color: HexColor("#456B4C"),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/Images/nplogo.png',
            fit: BoxFit.contain,
            width: 50,
            height: 40,
          ),
        ),
        Flexible(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<User?>(
                future: FirebaseAuth.instance.authStateChanges().first,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    User? user = snapshot.data;
                    String? email = user?.email;
                    String? username = email?.split('@').first;

                    return Text(
                      "$username's Progress",
                      style: const TextStyle(fontSize: 14.0),
                    );
                  } else {
                    return const Text('No user found');
                  }
                },
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
                    builder: (_) => LoggedOutHomePage(
                      onLoginOptionSelected: (bool value) {},
                    ),
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
                          builder: (_) => LoggedOutHomePage(
                            onLoginOptionSelected: (bool value) {},
                          ),
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
