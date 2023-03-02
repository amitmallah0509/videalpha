import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/router.gr.dart';
import '../view_model/auth_view_model.dart';

class SplashView extends StatelessWidget {
  SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Splash Screen show 2 seconds then it will be switch to user authentication flag;
    Timer(const Duration(seconds: 2), () {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final router = context.router;
      authViewModel.authStateChanges.listen((user) {
        router.replaceAll(
          user?.uid == null
              ? [LoginViewRoute()]
              : user?.name.isEmpty == true
                  ? [EditProfileViewRoute(user: user!)]
                  : [UserProfileViewRoute()],
        );
      });
    });

    return Container(
      color: Colors.white,
      child: Center(
        child: Image.asset(
          'assets/images/videAlpha.png',
          height: 200,
        ),
      ),
    );
  }
}
