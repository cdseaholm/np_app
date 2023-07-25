import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:np_app/view/authviews/user_regist.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import '../main_user_views/logged_out_homepage.dart';
import 'login_screen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: HexColor("#456B4C"),
              title: const Center(
                child: Text(
                  'Email has been sent',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Return to Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]);
        },
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (_emailController.text.trim().isEmpty) {
        emptyEmailMessage();
      } else if (e.code == 'user-not-found') {
        userNotFoundMessage();
      } else if (e.code == 'unauthorized-continue-uri') {
        unauthorizedURIMessage();
      } else if (e.code == 'invalid-continue-uri') {
        invalidURIMessage();
      } else if (e.code == 'missing-ios-bundle-id') {
        missingIOSIDMessage();
      } else if (e.code == 'missing-continue-uri') {
        missingURIMessage();
      } else if (e.code == 'missing-android-pkg-name') {
        missingAndroidPkgMessage();
      } else if (e.code == 'invalid-email') {
        invalidEmailMessage();
      }
    }
  }

  //emptyEmail
  void emptyEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: HexColor("#456B4C"),
            title: const Center(
              child: Text(
                'Email cannot be empty',
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ]);
      },
    );
  }

//auth/user-not-found
  void userNotFoundMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: HexColor("#456B4C"),
            title: const Center(
              child: Text(
                'Email cannot be found',
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegisterPage(
                        showLoginScreen: () {},
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Click here for Signup',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 40),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ]);
      },
    );
  }

//auth/unauthorized-continue-uri
  void unauthorizedURIMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: HexColor("#456B4C"),
            title: const Center(
              child: Text(
                'The domain of the continue URL is not whitelisted.',
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ]);
      },
    );
  }

//auth/invalid-continue-uri
  void invalidURIMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: HexColor("#456B4C"),
            title: const Center(
              child: Text(
                'The continue URL provided in the request is invalid.',
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ]);
      },
    );
  }

//auth/missing-ios-bundle-id
  void missingIOSIDMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: HexColor("#456B4C"),
            title: const Center(
              child: Text(
                'An iOS ID is needed.',
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ]);
      },
    );
  }

//auth/missing-continue-uri
  void missingURIMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: HexColor("#456B4C"),
            title: const Center(
              child: Text(
                'A continue URL must be provided.',
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ]);
      },
    );
  }

//auth/missing-android-pkg-name
  void missingAndroidPkgMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: HexColor("#456B4C"),
            title: const Center(
              child: Text(
                'An Android package name is required',
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ]);
      },
    );
  }

//auth/invalid-email
  void invalidEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: HexColor("#456B4C"),
            title: const Center(
              child: Text(
                'Email is Invalid',
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              padding: const EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 5.5,
              decoration: BoxDecoration(
                color: HexColor("#456B4C"),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(
                    150,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/Images/nplogo.png',
                        fit: BoxFit.contain,
                        width: 70,
                      ),
                    ),
                  ),
                  const SizedBox(
                      height: 16), // Add spacing between the image and text
                  const Center(
                    child: Text(
                      "NewProgress",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Forgot Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(children: [
              const Text(
                'Enter Your Email and we will send you a Password reset link',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 75, right: 75),
                child: GestureDetector(
                  onTap: passwordReset,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 76, 119, 85),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Reset Password',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text('Return to Login'),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoggedOutHomePage(),
                        ),
                      );
                    },
                    child: const Text('Return Home'),
                  ),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
