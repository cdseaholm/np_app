import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:np_app/view/main_user_views/logged_in_homepage.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class AuthRepository {
  const AuthRepository(this._auth);

  final FirebaseAuth _auth;

  Stream<User?> get authStateChange => _auth.idTokenChanges();

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('User not found');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Wrong password');
      } else if (e.code == 'user-disabled') {
        throw AuthException('User Disabled');
      } else if (e.code == 'invalid-email') {
        throw AuthException('Email is invalid');
      } else {
        throw AuthException('An error occured. Please try again later');
      }
    }
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() {
    return message;
  }
}

class GoogleAuthService {
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        return;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoggedInHomePage()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        accountExistsMessage(context);
      } else if (e.code == 'invalid-credential') {
        invalidCredMessage(context);
      } else if (e.code == 'user-disabled') {
        userDisMessage(context);
      } else if (e.code == 'user-not-found') {
        userNotFoundMessage(context);
      } else if (e.code == 'wrong-password') {
        wrongPasswordMessage(context);
      } else if (e.code == 'invalid-verification-code') {
        invalidVerificationMessage(context);
      } else if (e.code == 'invalid-verification-id') {
        invalidIDMessage(context);
      }
    }
  }

  void accountExistsMessage(BuildContext context) {
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
  void invalidCredMessage(BuildContext context) {
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
  void userDisMessage(BuildContext context) {
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
  void userNotFoundMessage(BuildContext context) {
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
  void wrongPasswordMessage(BuildContext context) {
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
  void invalidVerificationMessage(BuildContext context) {
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

  void invalidIDMessage(BuildContext context) {
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
}
