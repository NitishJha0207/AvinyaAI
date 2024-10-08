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
        return windows;
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
    apiKey: 'AIzaSyCMskrPypNxHxpyWPE4ytZQZt6tViwnAr8',
    appId: '1:335668504320:web:04bf7055a4d5a2b52eb5e5',
    messagingSenderId: '335668504320',
    projectId: 'avinyaai',
    authDomain: 'avinyaai.firebaseapp.com',
    databaseURL: 'https://avinyaai-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'avinyaai.appspot.com',
    measurementId: 'G-71GW1KXB9L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDk9Shd_QhgOzM4cF4BQlzjqAeZ9tBpJ2E',
    appId: '1:335668504320:android:42c83b81817acf912eb5e5',
    messagingSenderId: '335668504320',
    projectId: 'avinyaai',
    databaseURL: 'https://avinyaai-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'avinyaai.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAbXAA8Q3jlpKaTCxuhdiLsRGWkKikQEU0',
    appId: '1:335668504320:ios:14c7809ba34bce042eb5e5',
    messagingSenderId: '335668504320',
    projectId: 'avinyaai',
    databaseURL: 'https://avinyaai-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'avinyaai.appspot.com',
    androidClientId: '335668504320-8qtip0h5h5amh3p997oc389mpmndadc2.apps.googleusercontent.com',
    iosClientId: '335668504320-9kptflje081hcbkk8pk3eshbe0kshika.apps.googleusercontent.com',
    iosBundleId: 'com.avinyaai.aiguru',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAbXAA8Q3jlpKaTCxuhdiLsRGWkKikQEU0',
    appId: '1:335668504320:ios:14c7809ba34bce042eb5e5',
    messagingSenderId: '335668504320',
    projectId: 'avinyaai',
    databaseURL: 'https://avinyaai-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'avinyaai.appspot.com',
    androidClientId: '335668504320-8qtip0h5h5amh3p997oc389mpmndadc2.apps.googleusercontent.com',
    iosClientId: '335668504320-9kptflje081hcbkk8pk3eshbe0kshika.apps.googleusercontent.com',
    iosBundleId: 'com.avinyaai.aiguru',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCMskrPypNxHxpyWPE4ytZQZt6tViwnAr8',
    appId: '1:335668504320:web:1f090ff9d480b8012eb5e5',
    messagingSenderId: '335668504320',
    projectId: 'avinyaai',
    authDomain: 'avinyaai.firebaseapp.com',
    databaseURL: 'https://avinyaai-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'avinyaai.appspot.com',
    measurementId: 'G-6QZZHVNGG0',
  );

}