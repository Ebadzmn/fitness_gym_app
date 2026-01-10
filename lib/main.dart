import 'dart:async';
import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/core/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final SessionManager _sessionManager;
  StreamSubscription<void>? _sessionSubscription;

  @override
  void initState() {
    super.initState();
    _sessionManager = di.sl<SessionManager>();
    _sessionSubscription = _sessionManager.onSessionExpired.listen((_) {
      // Navigate to login page when session expires
      AppRouter.go(AppRoutes.loginPage);
    });
  }

  @override
  void dispose() {
    _sessionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => BlocProvider(
        create: (context) => di.sl<AuthBloc>(),
        child: MaterialApp.router(
          routerConfig: AppRouter,
          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme().copyWith(
              titleLarge: AppTextStyle.appbarHeading,
              headlineMedium: AppTextStyle.authHeading1,
              headlineSmall: AppTextStyle.authHeading2,
            ),
            scaffoldBackgroundColor: AppColor.primaryColor,
            primaryColor: AppColor.primaryColor,
            appBarTheme: AppBarTheme(
              titleTextStyle: AppTextStyle.appbarHeading,
              backgroundColor: AppColor.primaryColor,
            ),
          ),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
