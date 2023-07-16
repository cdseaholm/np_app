import 'package:flutter/material.dart';

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20.0),
                  children: const <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'To Come:',
                          style: TextStyle(fontSize: 24.0),
                        ),
                        Text(
                          'Community Rankings',
                          style: TextStyle(fontSize: 24.0),
                        ),
                        Text(
                          'Badges',
                          style: TextStyle(fontSize: 24.0),
                        ),
                        Text(
                          'Weekly Competitions',
                          style: TextStyle(fontSize: 24.0),
                        ),
                        Text(
                          'and more',
                          style: TextStyle(fontSize: 24.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
