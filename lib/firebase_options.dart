// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC2ePyALeQiVZUf2HRVZGWlY_RR14Aad1M',
    appId: '1:558308134520:web:4db33cb1e33ce0ae2b278d',
    messagingSenderId: '558308134520',
    projectId: 'quizz-app-64101',
    authDomain: 'quizz-app-64101.firebaseapp.com',
    storageBucket: 'quizz-app-64101.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBxaqAMfsF2t3VE73o6CMusVdcLDJYZswk',
    appId: '1:558308134520:android:b4f358aab7f9d2e22b278d',
    messagingSenderId: '558308134520',
    projectId: 'quizz-app-64101',
    storageBucket: 'quizz-app-64101.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDtR4aAE-u481bYq40pQtwZLWK1hyflQ0Y',
    appId: '1:558308134520:ios:4521b850ab4a4ed42b278d',
    messagingSenderId: '558308134520',
    projectId: 'quizz-app-64101',
    storageBucket: 'quizz-app-64101.appspot.com',
    iosBundleId: 'com.example.quizzApp',
  );
}
