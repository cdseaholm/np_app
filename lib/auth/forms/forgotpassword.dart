import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import '../../pages/logged_out_homepage.dart';
import 'login.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  String? emailError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      key: _scaffoldKey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            forgotpasswordUI(),
          ],
        ),
      ),
    );
  }

  Widget forgotpasswordUI() {
    return SingleChildScrollView(
        child: Form(
      key: globalKey,
      child: _forgotpasswordUI(context),
    ));
  }

  Widget _forgotpasswordUI(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [HexColor("#042c10"), HexColor("#053514")],
              ),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(
                  150,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/Images/nplogo.png',
                    fit: BoxFit.contain,
                    width: 60,
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
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20, top: 40),
              child: Text(
                "Forgotten Password",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
          ),
          const SizedBox(height: 100),
          FormHelper.inputFieldWidget(
            context,
            "email",
            "Email",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                setState(() {
                  emailError = 'Username cannot be empty';
                });
              } else if (onValidateVal.length < 4) {
                setState(() {
                  emailError = 'Username must be at least 4 characters';
                });
              } else {
                setState(() {
                  emailError = null;
                });
              }
              return null;
            },
            (onSendVal) {},
            initialValue: "",
            paddingBottom: 20,
            prefixIcon: const Icon(Icons.email),
            showPrefixIcon: true,
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
                'Enter your Email and we will send you a Reset Password Link',
                style: TextStyle(fontSize: 12.0)),
          ),
          if (emailError != null)
            Text(
              emailError!,
              style: const TextStyle(color: Colors.red),
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
                      builder: (_) => LoginScreen(
                        onSignInSuccess: () {},
                      ),
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
                        builder: (_) => const LoggedOutHomePage()),
                  );
                },
                child: const Text('Return Home'),
              ),
            ),
          ),
        ]);
  }
}
