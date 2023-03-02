// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i7;

import '../model/user_model.dart' as _i8;
import '../view/auth/login_view.dart' as _i2;
import '../view/auth/verify_view.dart' as _i3;
import '../view/edit_profile_view.dart' as _i5;
import '../view/splash_view.dart' as _i1;
import '../view/user_profile_view.dart' as _i4;

class AppRouter extends _i6.RootStackRouter {
  AppRouter([_i7.GlobalKey<_i7.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    SplashViewRoute.name: (routeData) {
      final args = routeData.argsAs<SplashViewRouteArgs>(
          orElse: () => const SplashViewRouteArgs());
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData, child: _i1.SplashView(key: args.key));
    },
    LoginViewRoute.name: (routeData) {
      final args = routeData.argsAs<LoginViewRouteArgs>(
          orElse: () => const LoginViewRouteArgs());
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData, child: _i2.LoginView(key: args.key));
    },
    VerifyViewRoute.name: (routeData) {
      final args = routeData.argsAs<VerifyViewRouteArgs>(
          orElse: () => const VerifyViewRouteArgs());
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData, child: _i3.VerifyView(key: args.key));
    },
    UserProfileViewRoute.name: (routeData) {
      final args = routeData.argsAs<UserProfileViewRouteArgs>(
          orElse: () => const UserProfileViewRouteArgs());
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData, child: _i4.UserProfileView(key: args.key));
    },
    EditProfileViewRoute.name: (routeData) {
      final args = routeData.argsAs<EditProfileViewRouteArgs>();
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i5.EditProfileView(key: args.key, user: args.user));
    }
  };

  @override
  List<_i6.RouteConfig> get routes => [
        _i6.RouteConfig(SplashViewRoute.name, path: '/'),
        _i6.RouteConfig(LoginViewRoute.name, path: '/login'),
        _i6.RouteConfig(VerifyViewRoute.name, path: '/verify'),
        _i6.RouteConfig(UserProfileViewRoute.name, path: '/profile'),
        _i6.RouteConfig(EditProfileViewRoute.name, path: '/edit-profile')
      ];
}

/// generated route for
/// [_i1.SplashView]
class SplashViewRoute extends _i6.PageRouteInfo<SplashViewRouteArgs> {
  SplashViewRoute({_i7.Key? key})
      : super(SplashViewRoute.name,
            path: '/', args: SplashViewRouteArgs(key: key));

  static const String name = 'SplashViewRoute';
}

class SplashViewRouteArgs {
  const SplashViewRouteArgs({this.key});

  final _i7.Key? key;

  @override
  String toString() {
    return 'SplashViewRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.LoginView]
class LoginViewRoute extends _i6.PageRouteInfo<LoginViewRouteArgs> {
  LoginViewRoute({_i7.Key? key})
      : super(LoginViewRoute.name,
            path: '/login', args: LoginViewRouteArgs(key: key));

  static const String name = 'LoginViewRoute';
}

class LoginViewRouteArgs {
  const LoginViewRouteArgs({this.key});

  final _i7.Key? key;

  @override
  String toString() {
    return 'LoginViewRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.VerifyView]
class VerifyViewRoute extends _i6.PageRouteInfo<VerifyViewRouteArgs> {
  VerifyViewRoute({_i7.Key? key})
      : super(VerifyViewRoute.name,
            path: '/verify', args: VerifyViewRouteArgs(key: key));

  static const String name = 'VerifyViewRoute';
}

class VerifyViewRouteArgs {
  const VerifyViewRouteArgs({this.key});

  final _i7.Key? key;

  @override
  String toString() {
    return 'VerifyViewRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i4.UserProfileView]
class UserProfileViewRoute extends _i6.PageRouteInfo<UserProfileViewRouteArgs> {
  UserProfileViewRoute({_i7.Key? key})
      : super(UserProfileViewRoute.name,
            path: '/profile', args: UserProfileViewRouteArgs(key: key));

  static const String name = 'UserProfileViewRoute';
}

class UserProfileViewRouteArgs {
  const UserProfileViewRouteArgs({this.key});

  final _i7.Key? key;

  @override
  String toString() {
    return 'UserProfileViewRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i5.EditProfileView]
class EditProfileViewRoute extends _i6.PageRouteInfo<EditProfileViewRouteArgs> {
  EditProfileViewRoute({_i7.Key? key, required _i8.UserModel user})
      : super(EditProfileViewRoute.name,
            path: '/edit-profile',
            args: EditProfileViewRouteArgs(key: key, user: user));

  static const String name = 'EditProfileViewRoute';
}

class EditProfileViewRouteArgs {
  const EditProfileViewRouteArgs({this.key, required this.user});

  final _i7.Key? key;

  final _i8.UserModel user;

  @override
  String toString() {
    return 'EditProfileViewRouteArgs{key: $key, user: $user}';
  }
}
