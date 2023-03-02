import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videalpha/app.dart';
import 'package:videalpha/view_model/auth_view_model.dart';
import 'package:videalpha/view_model/user_view_model.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      name: 'videAlpha',
      options: FirebaseOptions(
        projectId: 'videalpha-86f63',
        appId: Platform.isIOS
            ? '1:1082251867183:ios:df30e3fa7e8666dd3fc2da'
            : '1:1082251867183:android:5fed75ac5dbee2aa3fc2da',
        messagingSenderId: '1082251867183',
        apiKey: 'AIzaSyC8QJHax47avQOfhTPKu-6v577zEsFS15o',
        authDomain: 'videalpha-86f63.firebaseapp.com',
        storageBucket: 'videalpha-86f63.appspot.com',
      ),
    );
  } catch (e) {
    Firebase.app('videAlpha');
  }

  await FirebaseAppCheck.instance.activate();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ChangeNotifierProvider(create: (_) => UserViewModel()),
    ],
    child: App(),
  ));
}
