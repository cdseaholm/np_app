import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import '../../backend/auth_pages/authviews/user_regist_screen.dart';
import '../../backend/widget/botnavbar_widget.dart';
import 'calendarpage.dart';
import 'communitypage.dart';
import 'goalspage.dart';
import '../../backend/auth_pages/allthings_login/login_screen.dart';
import 'statisticspage.dart';

class LoggedOutHomePage extends StatefulWidget {
  const LoggedOutHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoggedOutHomePage> createState() => _LoggedOutHomePageState();
}

class _LoggedOutHomePageState extends State<LoggedOutHomePage> {
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
            _loggedOutHomeUI(context),
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

Widget _loggedOutHomeUI(BuildContext context) {
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
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
            child: const Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Already a Member? Login",
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()));
            },
            child: const Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Or Register Here",
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
