import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:np_app/auth/forms/login.dart';
import 'package:np_app/pages/logged_in_homepage.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import '../../pages/logged_out_homepage.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginScreen;
  const RegisterPage({Key? key, required this.showLoginScreen})
      : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  Future signUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        confirmPassword: _confirmPasswordController.text.trim(),
      );

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoggedInHomePage()));
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (_emailController.text.trim().isEmpty) {
        emptyEmailMessage();
      } else if (_passwordController.text.trim().isEmpty) {
        emptyPasswordMessage();
      } else if (_passwordController.text.trim() !=
          _confirmPasswordController.text.trim()) {
        passwordsMatchMessage();
      } else if (e.code == 'email-already-in-use') {
        emailInUseMessage();
      } else if (e.code == 'weak-password') {
        weakPasswordMessage();
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

  //emptyPassword
  void emptyPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: HexColor("#456B4C"),
            title: const Center(
              child: Text(
                'Password cannot be empty',
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

  //passwords match message
  void passwordsMatchMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: HexColor("#456B4C"),
            title: const Center(
              child: Text(
                'The Password and Confirm Password must match',
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

  // email in use message
  void emailInUseMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: HexColor("#456B4C"),
            title: const Center(
              child: Text(
                'This Email is in use already',
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

  //weak password
  void weakPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: HexColor("#456B4C"),
            title: const Center(
              child: Text(
                'Password is too weak, it must be at least 6 characters long',
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

  //invalid email
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                  "User SignUp",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),

            //email
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
            const SizedBox(height: 10),

            //password
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
                    controller: _passwordController,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          color: Colors.redAccent.withOpacity(.4),
                          icon: Icon(hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility)),
                      prefixIcon: const Icon(Icons.lock),
                      border: InputBorder.none,
                      hintText: 'Password',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            //confirm password
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
                    controller: _confirmPasswordController,
                    obscureText: hideConfirmPassword,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hideConfirmPassword = !hideConfirmPassword;
                            });
                          },
                          color: Colors.redAccent.withOpacity(.4),
                          icon: Icon(hideConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility)),
                      prefixIcon: const Icon(Icons.lock),
                      border: InputBorder.none,
                      hintText: 'Confirm Password',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.only(left: 75, right: 75),
              child: GestureDetector(
                onTap: signUp,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 76, 119, 85),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already a member? ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => LoginScreen(
                                onSignInSuccess: () {},
                              )),
                    );
                  },
                  child: const Text(
                    'Login here',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),

            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => LoggedOutHomePage(
                                onLoginOptionSelected: (bool value) {},
                              )),
                    );
                  },
                  child: const Text(
                    'Go Home',
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
