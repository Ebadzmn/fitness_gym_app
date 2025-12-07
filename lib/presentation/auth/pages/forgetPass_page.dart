import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/presentation/auth/widgets/customButton.dart';
import 'package:fitness_app/presentation/auth/widgets/customTextField.dart';
import 'package:fitness_app/presentation/auth/widgets/custom_Appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ForgetpassPage extends StatelessWidget {
  const ForgetpassPage({super.key});

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
              title: 'Forget Password',
              // onBackTap: () {}, // এখানে কিছু না দিলে ডিফল্টভাবে ব্যাক কাজ করবে
            ),

            SizedBox(height: 81.h),

            Text(
              'Forgot Password',
              style: AppTextStyle.authHeading1,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 11.h),
            
            Text(
              'Enter the email or phone your account and we’ll send a code to reset your password',
              style: AppTextStyle.authHeading2,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 24.h),

            CustomTextField(label: 'Email', hintText: 'Enter your email address', prefixIcon: Icons.email,
        
            ),

            SizedBox(height: 24.h),

            CustomButton(
              text: 'Send Code',
              onPressed: () {
                context.push(AppRoutes.otpPages);
              },
            ),
          ],
        ),
      ),
    );
  }
}