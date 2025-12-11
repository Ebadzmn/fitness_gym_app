import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkoutSessionPage extends StatelessWidget {
  const WorkoutSessionPage({super.key});

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
        title: Text(
          'Push Day – Chest & Shoulders',
          style: AppTextStyle.appbarHeading.copyWith(fontSize: 16.sp),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          children: [
            const _TimerSection(),
            SizedBox(height: 20.h),
            const _ExerciseCard(),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sets',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            const _SetsList(),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Notes',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            const _NotesInput(),
            SizedBox(height: 20.h),
            const _CoachNotes(),
            SizedBox(height: 30.h),
            const _BottomButtons(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class _TimerSection extends StatelessWidget {
  const _TimerSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Start!',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: const Color(0xFF13131F),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFF2E2E5D)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _timerItem('1', 'hours'),
              _divider(),
              _timerItem('10', 'Minutes'),
              _divider(),
              _timerItem('12', 'seconds'),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        // Play button
        Container(
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF2E5B24), width: 1.w),
          ),
          child: Icon(
            Icons.play_circle_outline,
            color: const Color(0xFF2E5B24),
            size: 32.sp,
          ),
        ),
      ],
    );
  }

  Widget _timerItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(height: 30.h, width: 1.w, color: Colors.white24);
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF13131F),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF2E5B24)), // Green border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bench Press',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'To Exchange',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFFF6D00),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFF2F3C50),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.fitness_center, size: 12.sp, color: Colors.blueGrey),
                SizedBox(width: 4.w),
                Text(
                  '4 Sets',
                  style: GoogleFonts.poppins(
                    color: Colors.blue,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SetsList extends StatelessWidget {
  const _SetsList();

  @override
  Widget build(BuildContext context) {
    return Column(children: List.generate(4, (index) => const _SetRow()));
  }
}

class _SetRow extends StatelessWidget {
  const _SetRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF13131F),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // Green Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFF2E5B24).withOpacity(0.3),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: const Color(0xFF2E5B24)),
            ),
            child: Column(
              children: [
                Text(
                  '8-10',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF4CAF50),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Wdh',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF4CAF50),
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          _inputBox('Geight', '62.5(Kg)'),
          SizedBox(width: 8.w),
          _inputBox('Reps(8)', ''),
          SizedBox(width: 8.w),
          _inputBox('RIR(2)', ''),
          SizedBox(width: 8.w),
          Icon(
            Icons.check_circle_outline,
            color: const Color(0xFF4CAF50),
            size: 24.sp,
          ),
        ],
      ),
    );
  }

  Widget _inputBox(String label, String value) {
    return Expanded(
      child: Container(
        height: 45.h,
        decoration: BoxDecoration(
          color: const Color(0XFF101021),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFF2E2E5D)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (value.isNotEmpty) ...[
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 10.sp,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ] else
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NotesInput extends StatelessWidget {
  const _NotesInput();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF13131F),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF2E2E5D)),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          'Type....',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14.sp),
        ),
      ),
    );
  }
}

class _CoachNotes extends StatelessWidget {
  const _CoachNotes();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2D3F),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Coach Notes',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Lorem ipsum dolor sit amet consectetur. Ipsum tortor nunc faucibus non interdum non mi.',
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}

class _BottomButtons extends StatelessWidget {
  const _BottomButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50.h,
            child: OutlinedButton(
              onPressed: () => context.pop(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF2E2E5D)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                backgroundColor: const Color(0xFF2B2D3F),
              ),
              child: Text(
                'Back',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: SizedBox(
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F146B), // Dark Blue
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                side: const BorderSide(color: Color(0xFF2E2E8D)),
              ),
              child: Text(
                'Complete',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
