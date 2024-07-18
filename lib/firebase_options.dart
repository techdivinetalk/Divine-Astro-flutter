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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
            'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC06RdHRB5jW2ri9DSbrd-fHh77yHaXJ1o',
    appId: '1:507681862980:android:06fefd7a24257e13e51311',
    messagingSenderId: '507681862980',
    projectId: 'divine-live-f7f79',
    databaseURL: 'https://divine-live-f7f79-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'divine-live-f7f79.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCDS5CxwYMh9O5Ao7bwlYmy4Xu5BUvShKU',
    appId: '1:507681862980:ios:3bdbdc4fdc0ae7eae51311',
    messagingSenderId: '507681862980',
    projectId: 'divine-live-f7f79',
    databaseURL: 'https://divine2-0-uat-default-rtdb.firebaseio.com',
    storageBucket: 'https://divine-live-f7f79-default-rtdb.asia-southeast1.firebasedatabase.app',
    androidClientId: '764246952124-ebi5t6dvglnm5picb03732ufvar0ekjm.apps.googleusercontent.com',
    iosClientId: '764246952124-o2nqves6l70ualttab3kd0dthfb0v7el.apps.googleusercontent.com',
    iosBundleId: 'app.divine.astrologer',
  );
}
