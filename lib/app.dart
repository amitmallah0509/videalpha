import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:videalpha/routes/router.gr.dart';
import 'package:videalpha/view/no_connection_view.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);
  final _appRouter = AppRouter();

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
    FirebaseAppCheck.instance.getToken(true);
    FirebaseAppCheck.instance.onTokenChange
        .listen((token) => print("AppCheck Token - $token"));

    return MaterialApp.router(
      routeInformationParser: _appRouter.defaultRouteParser(),
      routerDelegate: _appRouter.delegate(),
      theme: ThemeData(fontFamily: 'Quicksand'),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return NoConnectionView(
          widget: child!,
        );
      },
    );
  }
}
