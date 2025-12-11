import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text('Profile', style: AppTextStyle.appbarHeading),
        centerTitle: true,
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundColor: Colors.grey.shade800,
                    child: Icon(Icons.person_outline, size: 40.sp, color: Colors.white),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColor.primaryColor, width: 2),
                      ),
                      child: Icon(Icons.camera_alt_outlined, size: 14.sp, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            // Personal Data
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF13131F),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFF2E2E5D)),
              ),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader(Icons.person_outline, 'Personal Data'),
                  SizedBox(height: 16.h),
                  _infoRow('Full Name', 'John Doe'),
                  SizedBox(height: 12.h),
                  _infoRow('Email', 'Max@examole.com'),
                  SizedBox(height: 12.h),
                  _infoRow('Gender', 'Male'),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            // Athlete Info
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF13131F),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFF2E2E5D)),
              ),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader(Icons.person_outline, 'Athlete Info'),
                  SizedBox(height: 16.h),
                  _infoRow('Status', 'NATURAL', valueColor: const Color(0xFFFFCC00)),
                  SizedBox(height: 12.h),
                  _infoRow('Category', 'Lifestyle', valueColor: Colors.green),
                  SizedBox(height: 12.h),
                  _infoRow('Check-in day', 'Sunday'),
                  SizedBox(height: 12.h),
                  _infoRow('Hight (cm)', '180 (cm)'),
                  SizedBox(height: 12.h),
                  _infoRow('Age', '22 Years'),
                  SizedBox(height: 12.h),
                  _infoRow('Goal', 'Lose body fat'),
                  SizedBox(height: 12.h),
                  _infoRow('Training Day Steps', '10 Step'),
                  SizedBox(height: 12.h),
                  _infoRow('Rest day Steps', '10 Step'),
                  SizedBox(height: 12.h),
                  _infoRow('Assigned Cardio per Week', '10 (min)'),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            // Account
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF13131F),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFF2E2E5D)),
              ),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader(Icons.person_outline, 'Account', iconColor: Colors.yellow),
                  SizedBox(height: 16.h),
                  _infoRow('Role', 'Cilent', valueColor: const Color(0xFFFFCC00)),
                  SizedBox(height: 12.h),
                  _infoRow('Coach', 'Jhon Doe'),
                  SizedBox(height: 12.h),
                  _infoRow('Member since', '1 / 10 / 2022'),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            // Show Information
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF13131F),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFF2E2E5D)),
              ),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader(Icons.emoji_events_outlined, 'Show Informetion', iconColor: Colors.green),
                  SizedBox(height: 16.h),
                  _infoRow('Show Name', 'WBFF Muscle', valueColor: const Color(0xFFFFCC00)),
                  SizedBox(height: 12.h),
                  _infoRow('Show Date', '12 August 2024', valueColor: Colors.green),
                  SizedBox(height: 12.h),
                  _infoRow('Location', 'Olympia Hall, Germany'),
                  SizedBox(height: 12.h),
                  _infoRow('Division', 'WBFF'),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            // Table
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  topRight: Radius.circular(8.r),
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Container(  
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.r),
                        topRight: Radius.circular(8.r),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Row(
                      children: [
                        Expanded(flex: 1, child: Text('Week', textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp))),
                        Container(width: 1, height: 16.h, color: Colors.white24),
                        Expanded(flex: 2, child: Text('Date', textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp))),
                        Container(width: 1, height: 16.h, color: Colors.white24),
                        Expanded(flex: 2, child: Text('Phase', textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp))),
                        Container(width: 1, height: 16.h, color: Colors.white24),
                        Expanded(flex: 2, child: Text('Bodyweight', textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp))),
                        
                      ],
                    ),
                  ),
                  // Rows
                  _tableRow('1', '30 Dec,24', '70 kg', 'korpegewich', const Color(0xFFD4AF37)),
                  _tableRow('2', '30 Dec,24', '70.5 kg', 'korpegewich', const Color(0xFFD4AF37)),
                  _tableRow('3', '30 Dec,24', '71 kg', 'korpegewich', const Color(0xFFD4AF37)),
                  _tableRow('4', '30 Dec,24', '71.5 kg', 'korpegewich', const Color(0xFF8B4513)),
                  _tableRow('5', '30 Dec,24', '72 kg', 'korpegewich', const Color(0xFF8B4513)),
                  _tableRow('6', '30 Dec,24', '72.5 kg', 'korpegewich', const Color(0xFF4CAF50)),
                  _tableRow('7', '30 Dec,24', '73 kg', 'Offseason', const Color(0xFF4CAF50)),
                ],
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _tableRow(String week, String date, String weight, String phase, Color phaseColor) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white24)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.black,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Text(week, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp)),
              ),
            ),
            Container(width: 1, color: Colors.white24),
            Expanded(
              flex: 2,
              child: Container(
                color: const Color(0xFF2C2C3E),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Text(date, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp)),
              ),
            ),
            Container(width: 1, color: Colors.white24),
            Expanded(
              flex: 2,
              child: Container(
                color: phaseColor,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        phase,
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.white, size: 18.sp),
                  ],
                ),
              ),
            ),
            Container(width: 1, color: Colors.white24),
            Expanded(
              flex: 2,
              child: Container(
                color: const Color(0xFF2C2C3E),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Text(weight, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title, {Color? iconColor}) {
    return Row(
      children: [
        Icon(icon, color: iconColor ?? const Color(0xFF82C941), size: 20.sp), // Using the app's green color
        SizedBox(width: 8.w),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: valueColor ?? Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
