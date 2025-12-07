import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/presentation/checkIn/widgets/checkIn_widgets.dart';
import 'package:fitness_app/presentation/checkIn/widgets/questions_tab.dart';
import 'package:fitness_app/presentation/checkIn/widgets/checking_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/core/coreWidget/full_width_slider.dart';

class CheckinPages extends StatefulWidget {
  const CheckinPages({super.key});

  @override
  State<CheckinPages> createState() => _CheckinPagesState();
}

class _CheckinPagesState extends State<CheckinPages> {
  int _currentStep = 0;

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Finish or Submit
    }
  }

  void _goToStep(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: CircleAvatar(
            backgroundColor: Colors.white10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        title: Text("Check -In", style: AppTextStyle.appbarHeading),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Steps Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => _goToStep(0),
                  child: CheckInStep(
                    icon: Icons.person_outline,
                    label: "Profile",
                    isActive: _currentStep == 0,
                    isCompleted: _currentStep > 0,
                  ),
                ),
                GestureDetector(
                  onTap: () => _goToStep(1),
                  child: CheckInStep(
                    icon: Icons.camera_alt_outlined,
                    label: "Photos",
                    isActive: _currentStep == 1,
                    isCompleted: _currentStep > 1,
                  ),
                ),
                GestureDetector(
                  onTap: () => _goToStep(2),
                  child: CheckInStep(
                    icon: Icons.chat_bubble_outline,
                    label: "Questions",
                    isActive: _currentStep == 2,
                    isCompleted: _currentStep > 2,
                  ),
                ),
                GestureDetector(
                  onTap: () => _goToStep(3),
                  child: CheckInStep(
                    icon: Icons.check_circle_outline,
                    label: "Checking",
                    isActive: _currentStep == 3,
                    isCompleted: _currentStep > 3,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),

            // Dynamic Body
            _buildBody(),

            SizedBox(height: 40.h),

            // Bottom Button
            if (_currentStep == 3) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _goToStep(2),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F0F3E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: const BorderSide(color: Color(0xFF2E2E5D)),
                        ),
                      ),
                      child: Text(
                        'Back',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1F1F7E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: const BorderSide(color: Color(0xFF2E2E5D)),
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                height: 55.h,
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F0F3E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: const BorderSide(color: Color(0xFF2E2E5D)),
                    ),
                  ),
                  child: Text(
                    _currentStep == 1 ? 'Upload' : 'Next',
                    style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_currentStep == 0) {
      return Column(
        children: [
          // Basic Data Header
          Row(
            children: [
              Icon(
                Icons.monitor_weight_outlined,
                color: Colors.white,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                "Basic Data",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Data Cards
          const CheckInCard(
            title: "competition class",
            value: "Classic Physique",
            icon: Icons.emoji_events_outlined,
          ),
          const CheckInCard(
            title: "Current Weight (kg)",
            value: "80.2 (kg)",
            showBadge: true,
          ),
          const CheckInCard(
            title: "Average Weight in %",
            value: "80.2 (%)",
            showBadge: true,
          ),
        ],
      );
    } else if (_currentStep == 1) {
      return Column(
        children: [
          InstructionText(
            icon: Icons.description_outlined,
            text:
                "You Can Select Multiple Files, But At Least One File Must Be Chosen",
          ),
          SizedBox(height: 16.h),
          FileUploadWidget(
            label: "Select File",
            onTap: () {
              // Handle file selection
            },
          ),
          SizedBox(height: 24.h),
          InstructionText(
            icon: Icons.play_circle_outline,
            text:
                "Only One Video Can Be Uploaded, And The Maximum File Size Is 500 MB.",
          ),
          SizedBox(height: 16.h),
          VideoUploadWidget(
            label: "Drag & drop video file",
            onTap: () {
              // Handle video selection
            },
          ),
        ],
      );
    } else if (_currentStep == 2) {
      return const QuestionsTab();
    } else if (_currentStep == 3) {
      return const CheckingTab();
    }
    return Container(); // Placeholder for other steps
  }
}
 

 
