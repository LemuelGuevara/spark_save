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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCMgjC96nnzrRJ5cz0-wX_MUkn2zbhmlAE',
    appId: '1:923233736133:web:5b9e31e953ad9f9a6567ac',
    messagingSenderId: '923233736133',
    projectId: 'spark-save',
    authDomain: 'spark-save.firebaseapp.com',
    storageBucket: 'spark-save.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCLYaxA8GDIIM_m3MtTR7F8QCI6cG6ruKc',
    appId: '1:923233736133:android:703609dac2ca975c6567ac',
    messagingSenderId: '923233736133',
    projectId: 'spark-save',
    storageBucket: 'spark-save.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBPNzFXX8GUp1yUyc96VLawKDRifVRjp-Q',
    appId: '1:923233736133:ios:a7d0333fe1a83b3e6567ac',
    messagingSenderId: '923233736133',
    projectId: 'spark-save',
    storageBucket: 'spark-save.firebasestorage.app',
    iosBundleId: 'com.example.sparkSave',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBPNzFXX8GUp1yUyc96VLawKDRifVRjp-Q',
    appId: '1:923233736133:ios:a7d0333fe1a83b3e6567ac',
    messagingSenderId: '923233736133',
    projectId: 'spark-save',
    storageBucket: 'spark-save.firebasestorage.app',
    iosBundleId: 'com.example.sparkSave',
  );
}
