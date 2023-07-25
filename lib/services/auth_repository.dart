import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:np_app/view/main_user_views/logged_in_homepage.dart';

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

  Future<void> signOut() async {
    await _auth.signOut();
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
      if (e.code == 'user-not-found') {
        throw AuthException('User not found');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Wrong password');
      } else if (e.code == 'user-disabled') {
        throw AuthException('User Disabled');
      } else if (e.code == 'account-exists-with-different-credential') {
        throw AuthException('Account exists with different credentials');
      } else if (e.code == 'invalid-credential') {
        throw AuthException('Invalid credential');
      } else if (e.code == 'invalid-verification-code') {
        throw AuthException('Invalid verification');
      } else if (e.code == 'invalid-verification-id') {
        throw AuthException('Invalid ID');
      } else {
        throw AuthException('An error occured. Please try again later');
      }
    }
  }
}
