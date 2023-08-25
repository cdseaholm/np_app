import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_app/backend/update_profile_all/profile_page.dart';

import '../../backend/widget/botnavbar_widget.dart';
import '../../backend/widget/display_name_widget.dart';
import '../../backend/tasks(all)/task.dart';
import 'calendarpage.dart';
import 'communitypage.dart';
import 'goalspage.dart';
import 'logged_out_homepage.dart';
import 'statisticspage.dart';

class LoggedInHomePage extends ConsumerStatefulWidget {
  const LoggedInHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LoggedInHomePageState();
}

class _LoggedInHomePageState extends ConsumerState<LoggedInHomePage> {
  late int _currentIndex;
  late ValueChanged<int> onTappedbar;
  late PageController _pageController;
  final user = FirebaseAuth.instance.currentUser!;
  late List<bool> hideEditButtons;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
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
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: const [
                  SafeArea(child: Tasks()),
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
              title: const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    radius: 25,
                    child: Text(
                      'NP',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                    ),
                  ),
                  title: Center(
                    child: HomeDisplayNameWidget(),
                  )),
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
                              child: MaterialButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProfilePage(),
                                  ),
                                ),
                                child: const Text('Profile'),
                              ),
                            ),
                            PopupMenuItem<String>(
                              child: MaterialButton(
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const LoggedOutHomePage()),
                                  );
                                },
                                child: const Text('Logout'),
                              ),
                            ),
                            PopupMenuItem<String>(
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Close'),
                              ),
                            )
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
