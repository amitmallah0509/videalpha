import 'package:auto_route/auto_route.dart';
import 'package:videalpha/view/auth/login_view.dart';
import 'package:videalpha/view/auth/verify_view.dart';
import 'package:videalpha/view/edit_profile_view.dart';
import 'package:videalpha/view/splash_view.dart';
import 'package:videalpha/view/user_profile_view.dart';

@MaterialAutoRouter(routes: [
  AutoRoute(path: '/', page: SplashView, initial: true),
  AutoRoute(path: '/login', page: LoginView),
  AutoRoute(path: '/verify', page: VerifyView),
  AutoRoute(path: '/profile', page: UserProfileView),
  AutoRoute(path: '/edit-profile', page: EditProfileView),
])
class $AppRouter {}
