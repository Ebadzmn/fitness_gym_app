import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'injection_container.dart' as di;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
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
    );
  }
}
