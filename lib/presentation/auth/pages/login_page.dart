import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/presentation/auth/widgets/customButton.dart';
import 'package:fitness_app/presentation/auth/widgets/customTextField.dart';
import 'package:fitness_app/presentation/auth/widgets/custom_Appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
        child: Column(
          children: [
            SizedBox(height: 10.h),

            /// --- Reusable AppBar ---
            const CustomAppBar(
              title: 'Login',
              // onBackTap: () {}, // এখানে কিছু না দিলে ডিফল্টভাবে ব্যাক কাজ করবে
            ),

            SizedBox(height: 70.h),

            Text(
              'Wolf Wind',
              style: AppTextStyle.authHeading1,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 11.h),

           

            SizedBox(height: 52.h),

            const CustomTextField(
              hintText: 'Enter your email',
              label: 'Email',
              prefixIcon: Icons.email,
            ),

            SizedBox(height: 24.h),

            const CustomTextField(
              hintText: 'Enter your password',
              label: 'Password',
              prefixIcon: Icons.lock,
              isPassword: true,
              suffixIcon: Icon(Icons.visibility),
            ),

            SizedBox(height: 24.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    context.push(AppRoutes.forgetPassPage);
                  },
                  child: Text(
                    'Forgot password?',
                    style: AppTextStyle.authHeading3,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            CustomButton(
              text: 'Login',
              onPressed: () {
                context.push(AppRoutes.homePage);
              },
            ),
          ],
        ),
      ),
    );
  }
}
