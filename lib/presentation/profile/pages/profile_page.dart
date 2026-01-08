import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fitness_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:fitness_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileBloc>()..add(const ProfileLoadRequested()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

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
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ProfileStatus.failure) {
            return Center(
              child: Text(
                'Error: ${state.errorMessage}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          if (state.status == ProfileStatus.success && state.profile != null) {
            final profile = state.profile!;
            final athlete = profile.athlete;

            return SingleChildScrollView(
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
                          backgroundImage: athlete.image.isNotEmpty
                              ? NetworkImage(athlete.image)
                              : null,
                          child: athlete.image.isEmpty
                              ? Icon(
                                  Icons.person_outline,
                                  size: 40.sp,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(4.r),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColor.primaryColor,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 14.sp,
                              color: Colors.black,
                            ),
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
                        _infoRow('Full Name', athlete.name),
                        SizedBox(height: 12.h),
                        _infoRow('Email', athlete.email),
                        SizedBox(height: 12.h),
                        _infoRow('Gender', athlete.gender),
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
                        _infoRow(
                          'Status',
                          athlete.status,
                          valueColor: const Color(0xFFFFCC00),
                        ),
                        SizedBox(height: 12.h),
                        _infoRow(
                          'Category',
                          athlete.category,
                          valueColor: Colors.green,
                        ),
                        SizedBox(height: 12.h),
                        _infoRow('Check-in day', athlete.checkInDay),
                        SizedBox(height: 12.h),
                        _infoRow('Hight (cm)', '${athlete.height} (cm)'),
                        SizedBox(height: 12.h),
                        _infoRow('Age', '${athlete.age} Years'),
                        SizedBox(height: 12.h),
                        _infoRow('Goal', athlete.goal),
                        SizedBox(height: 12.h),
                        _infoRow(
                          'Training Day Steps',
                          '${athlete.trainingDaySteps} Step',
                        ),
                        SizedBox(height: 12.h),
                        _infoRow(
                          'Rest day Steps',
                          '${athlete.restDaySteps} Step',
                        ),
                        SizedBox(height: 12.h),
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
                        _sectionHeader(
                          Icons.person_outline,
                          'Account',
                          iconColor: Colors.yellow,
                        ),
                        SizedBox(height: 16.h),
                        _infoRow(
                          'Role',
                          athlete.role,
                          valueColor: const Color(0xFFFFCC00),
                        ),
                        SizedBox(height: 12.h),
                        _infoRow('Coach', profile.coachName),
                        SizedBox(height: 12.h),
                        _infoRow(
                          'Member since',
                          _formatDate(athlete.createdAt),
                        ),
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
                        _sectionHeader(
                          Icons.emoji_events_outlined,
                          'Show Information',
                          iconColor: Colors.green,
                        ),
                        SizedBox(height: 16.h),
                        _infoRow(
                          'Show Name',
                          'WBFF Muscle',
                          valueColor: const Color(0xFFFFCC00),
                        ), // Placeholder or missing in response? Using static for now if not in Entity
                        SizedBox(height: 12.h),
                        _infoRow(
                          'Show Date',
                          profile.show.date,
                          valueColor: Colors.green,
                        ),
                        SizedBox(height: 12.h),
                        _infoRow(
                          'Location',
                          'Olympia Hall, Germany',
                        ), // Placeholder
                        SizedBox(height: 12.h),
                        _infoRow('Division', 'WBFF'), // Placeholder
                        SizedBox(height: 12.h),
                        _infoRow('Countdown', '${profile.countDown} Days'),
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
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Week',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 16.h,
                                color: Colors.white24,
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Date',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 16.h,
                                color: Colors.white24,
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Phase',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Rows
                        if (profile.timeline.nextCheckInDate.isNotEmpty)
                          _tableRow(
                            '1',
                            _formatDate(profile.timeline.nextCheckInDate),
                            profile.timeline.phase,
                            const Color(0xFFD4AF37),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            );
          }
          return const Center(
            child: Text(
              'No profile data found',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day} / ${date.month} / ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Widget _tableRow(String week, String date, String phase, Color phaseColor) {
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
                child: Text(
                  week,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
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
                child: Text(
                  date,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
            Container(width: 1, color: Colors.white24),
            Expanded(
              flex: 2,
              child: Container(
                color: phaseColor,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                child: Text(
                  phase,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
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
        Icon(icon, color: iconColor ?? const Color(0xFF82C941), size: 20.sp),
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
