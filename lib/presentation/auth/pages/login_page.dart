import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fitness_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:fitness_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:fitness_app/presentation/auth/widgets/customButton.dart';
import 'package:fitness_app/presentation/auth/widgets/customTextField.dart';
import 'package:fitness_app/presentation/auth/widgets/custom_Appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go(AppRoutes.homePage);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
              child: Column(
                children: [
                  SizedBox(height: 10.h),

                  /// --- Reusable AppBar ---
                  const CustomAppBar(title: 'Login'),

                  SizedBox(height: 70.h),

                  Text(
                    'Wolves Win.',
                    style: AppTextStyle.authHeading1,
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 11.h),

                  SizedBox(height: 52.h),

                  CustomTextField(
                    controller: emailController,
                    hintText: 'Enter your email',
                    label: 'Email',
                    prefixIcon: Icons.email,
                  ),

                  SizedBox(height: 24.h),

                  CustomTextField(
                    controller: passwordController,
                    hintText: 'Enter your password',
                    label: 'Password',
                    prefixIcon: Icons.lock,
                    isPassword: true,
                    suffixIcon: const Icon(Icons.visibility),
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

                  state is AuthLoading
                      ? const CircularProgressIndicator()
                      : CustomButton(
                          text: 'Login',
                          onPressed: () {
                            context.read<AuthBloc>().add(
                              LoginRequested(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
