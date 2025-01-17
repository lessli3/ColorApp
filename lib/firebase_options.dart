// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCppDzbr36yO-HTkrfuFqBGNtPzRijdx6s',
    appId: '1:254123447478:web:d108e16001071583604217',
    messagingSenderId: '254123447478',
    projectId: 'colorapp-edc24',
    authDomain: 'colorapp-edc24.firebaseapp.com',
    storageBucket: 'colorapp-edc24.appspot.com',
    measurementId: 'G-V4DGVWFC2V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA4yzta93ywMZch-44aVkNI9FxjtiBG7CY',
    appId: '1:254123447478:android:8a84c4829c4b0616604217',
    messagingSenderId: '254123447478',
    projectId: 'colorapp-edc24',
    storageBucket: 'colorapp-edc24.appspot.com',
  );
}
