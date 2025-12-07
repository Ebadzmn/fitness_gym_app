import 'package:fitness_app/presentation/auth/pages/forgetPass_page.dart';
import 'package:fitness_app/presentation/auth/pages/otp_pages.dart';
import 'package:fitness_app/presentation/checkIn/pages/checkIn_pages.dart';
import 'package:fitness_app/presentation/home/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/presentation/auth/pages/login_page.dart';
import 'package:fitness_app/presentation/auth/pages/splash_page.dart';

import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String splashPage = '/splash';
  static const String loginPage = '/login';
  static const String forgetPassPage = '/forgetPass';
  static const String otpPages = '/otpPages';
  static const String homePage = '/home';
  static const String checkinPages = '/checkinPages';



  static Page<dynamic> fadeTransitionPage({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<dynamic>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}

final GoRouter AppRouter = GoRouter(
  initialLocation: AppRoutes.splashPage,
  routes: [
    GoRoute(
      path: AppRoutes.splashPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const SplashPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.loginPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.forgetPassPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const ForgetpassPage(),
      ),
    ),

    GoRoute(
      path: AppRoutes.otpPages,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: OtpPages(),
      ),
    ),

    GoRoute(
      path: AppRoutes.homePage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const HomePage(),
      ),
    ),

    GoRoute(
      path: AppRoutes.checkinPages,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const CheckinPages(),
      ),
    ),
  ],
);
