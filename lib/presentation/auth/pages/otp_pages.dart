import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/presentation/auth/widgets/customButton.dart';
import 'package:fitness_app/presentation/auth/widgets/customTextField.dart';
import 'package:fitness_app/presentation/auth/widgets/custom_Appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OtpPages extends StatelessWidget {
  const OtpPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w , vertical: 32.h),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            CustomAppBar(title: 'OTP Verification', showBackButton: true,),

            SizedBox(height: 69.h),

            Text(
              'Check your email',
              style: AppTextStyle.authHeading1,
            ),

            SizedBox(height: 11.h),

            Text(
              'We send a verification code Please Check your e-mail',
              style: AppTextStyle.authHeading2,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 24.h),

           CustomTextField(label: 'OTP', hintText: 'Enter OTP', prefixIcon: Icons.lock),
            SizedBox(height: 18.h),

           Text('This code will expire in 01:56', style: AppTextStyle.authHeading2, textAlign: TextAlign.center,),
            SizedBox(height: 20.h),
            CustomButton(
              text: 'Verify',
              onPressed: () {
                context.push(AppRoutes.createNewPasswordPage);
              },
            ),
          ],
        ),
      ),
    );
  }
}
