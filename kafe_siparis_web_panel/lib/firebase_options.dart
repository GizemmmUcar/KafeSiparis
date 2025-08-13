import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyBFbb5VymqtxkizEDW5gvrSUG7aqiTz5bY",
    authDomain: "kafesiparis-47b18.firebaseapp.com",
    projectId: "kafesiparis-47b18",
    storageBucket: "kafesiparis-47b18.appspot.com",
    messagingSenderId: "818186152052",
    appId: "1:818186152052:web:83cb3b9a1330d8503a8921",
    measurementId: "G-66S6954RG7",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBFbb5VymqtxkizEDW5gvrSUG7aqiTz5bY",
    authDomain: "kafesiparis-47b18.firebaseapp.com",
    projectId: "kafesiparis-47b18",
    storageBucket: "kafesiparis-47b18.appspot.com",
    messagingSenderId: "818186152052",
    appId: "1:818186152052:web:83cb3b9a1330d8503a8921",
    measurementId: "G-66S6954RG7",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyBFbb5VymqtxkizEDW5gvrSUG7aqiTz5bY",
    authDomain: "kafesiparis-47b18.firebaseapp.com",
    projectId: "kafesiparis-47b18",
    storageBucket: "kafesiparis-47b18.appspot.com",
    messagingSenderId: "818186152052",
    appId: "1:818186152052:web:83cb3b9a1330d8503a8921",
    measurementId: "G-66S6954RG7",
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: "AIzaSyBFbb5VymqtxkizEDW5gvrSUG7aqiTz5bY",
    authDomain: "kafesiparis-47b18.firebaseapp.com",
    projectId: "kafesiparis-47b18",
    storageBucket: "kafesiparis-47b18.appspot.com",
    messagingSenderId: "818186152052",
    appId: "1:818186152052:web:83cb3b9a1330d8503a8921",
    measurementId: "G-66S6954RG7",
  );
}
