import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:np_app/auth/forms/forgotpassword.dart';
import 'package:np_app/auth/forms/user_regist.dart';
import 'package:np_app/pages/logged_in_homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onSignInSuccess;

  const LoginScreen({Key? key, required this.onSignInSuccess})
      : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool remainSignedIn = false;

  void onSignInSuccess() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Remain Signed In?', remainSignedIn);

    widget.onSignInSuccess();
  }

  Future signIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
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
      } else if (e.code == 'user-not-found') {
        wrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        wrongPasswordMessage();
      } else if (e.code == 'user-disabled') {
        userDisabledMessage();
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

  //user not found
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: HexColor("#456B4C"),
            title: const Center(
              child: Text(
                'The Email was Incorrect',
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

  // wrong password
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: HexColor("#456B4C"),
            title: const Center(
              child: Text(
                'The Password was Incorrect',
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPassword(),
                    ),
                  );
                },
                child: const Text(
                  'Forgot Password? Click here',
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

  //user disabled (for future when using users)
  void userDisabledMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: HexColor("#456B4C"),
            title: const Center(
              child: Text(
                'This Email has been disabled or changed',
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
    super.dispose();
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
                  "Welcome Back!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ],
            ),

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),

            const SizedBox(height: 20),

            //Email

            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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

              //forgot email
              Container(
                height: 30,
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ForgotPassword()),
                      );
                    },
                    child: const Text(
                      'Forgot Email?',
                      style: TextStyle(color: Colors.blue, fontSize: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

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

              //forgot password
              Container(
                height: 30,
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ForgotPassword()),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blue, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.only(left: 75, right: 75),
              child: GestureDetector(
                onTap: signIn,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 76, 119, 85),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Container(
              height: 30,
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  const Text(
                    'Remain Signed In?',
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Checkbox(
                        value: remainSignedIn,
                        onChanged: (value) {
                          setState(() {
                            remainSignedIn = value ?? false;
                          });
                        },
                      );
                    },
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            // google + apple sign in buttons
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // google button
                //SquareTile(imagePath: 'lib/images/google.png'),

                SizedBox(width: 25),

                // apple button
                //SquareTile(imagePath: 'lib/images/apple.png')
              ],
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Not a member? ',
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
                          builder: (_) => RegisterPage(
                                showLoginScreen: () {},
                              )),
                    );
                  },
                  child: const Text(
                    'Register here',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
