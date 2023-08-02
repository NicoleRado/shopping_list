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
    apiKey: 'AIzaSyC24Bf25hKfyqeWuh6KmYxWmUgS5sid4bI',
    appId: '1:681197503448:web:c6f449c89080e3dab8a8ad',
    messagingSenderId: '681197503448',
    projectId: 'shoppinglist-81ec6',
    authDomain: 'shoppinglist-81ec6.firebaseapp.com',
    storageBucket: 'shoppinglist-81ec6.appspot.com',
    measurementId: 'G-Z197KJFPXX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBreNxN94kaOe8dYnG3rW6kSNg4_oZRCng',
    appId: '1:681197503448:android:d0ca4c5db78e04fdb8a8ad',
    messagingSenderId: '681197503448',
    projectId: 'shoppinglist-81ec6',
    storageBucket: 'shoppinglist-81ec6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCDkyMSSGcsMSTfaL4s1AsxUnsT5M-L06M',
    appId: '1:681197503448:ios:06b49f3218842919b8a8ad',
    messagingSenderId: '681197503448',
    projectId: 'shoppinglist-81ec6',
    storageBucket: 'shoppinglist-81ec6.appspot.com',
    iosClientId: '681197503448-hdaotq15r1egc7dbd0eu6pt9jj89oof0.apps.googleusercontent.com',
    iosBundleId: 'com.example.shoppingList',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCDkyMSSGcsMSTfaL4s1AsxUnsT5M-L06M',
    appId: '1:681197503448:ios:fc86383ba248f409b8a8ad',
    messagingSenderId: '681197503448',
    projectId: 'shoppinglist-81ec6',
    storageBucket: 'shoppinglist-81ec6.appspot.com',
    iosClientId: '681197503448-62agqkvgtlrtp858vrjsjgdm39t82bll.apps.googleusercontent.com',
    iosBundleId: 'com.example.shoppingList.RunnerTests',
  );
}
