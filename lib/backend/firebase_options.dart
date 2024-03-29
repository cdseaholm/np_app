// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions web = FirebaseOptions(
    apiKey: '${dotenv.env["WEBAPIKEY"]}',
    appId: '${dotenv.env["WEBAPPID"]}',
    messagingSenderId: '${dotenv.env["MESSAGINGSENDERID"]}',
    projectId: '${dotenv.env["PROJECTID"]}',
    authDomain: '${dotenv.env["WEBAUTHDOMAIN"]}',
    databaseURL: '${dotenv.env["DATABASEURL"]}',
    storageBucket: '${dotenv.env["STORAGEBUCKET"]}',
    measurementId: '${dotenv.env["WEBMEASUREMENTID"]}',
  );

  static FirebaseOptions android = FirebaseOptions(
    apiKey: '${dotenv.env["ANDROIDAPIKEY"]}',
    appId: '${dotenv.env["ANDROIDAPPID"]}',
    messagingSenderId: '${dotenv.env["MESSAGINGSENDERID"]}',
    projectId: '${dotenv.env["PROJECTID"]}',
    databaseURL: '${dotenv.env["DATABASEURL"]}',
    storageBucket: '${dotenv.env["STORAGEBUCKET"]}',
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: '${dotenv.env["IOSAPIKEY"]}',
    appId: '${dotenv.env["IOSAPPID"]}',
    messagingSenderId: '${dotenv.env["MESSAGINGSENDERID"]}',
    projectId: '${dotenv.env["PROJECTID"]}',
    databaseURL: '${dotenv.env["DATABASEURL"]}',
    storageBucket: '${dotenv.env["STORAGEBUCKET"]}',
    iosBundleId: '${dotenv.env["IOSIOSBUNDLEID"]}',
  );

  static FirebaseOptions macos = FirebaseOptions(
    apiKey: '${dotenv.env["IOSAPIKEY"]}',
    appId: '${dotenv.env["IOSAPPID"]}',
    messagingSenderId: '${dotenv.env["MESSAGINGSENDERID"]}',
    projectId: '${dotenv.env["PROJECTID"]}',
    databaseURL: '${dotenv.env["DATABASEURL"]}',
    storageBucket: '${dotenv.env["STORAGEBUCKET"]}',
    iosBundleId: '${dotenv.env["IOSIOSBUNDLEID"]}',
  );
}
