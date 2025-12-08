import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/domain/entities/training_entities/training_history_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingHistoryDetailPage extends StatelessWidget {
  final TrainingHistoryEntity historyItem;

  const TrainingHistoryDetailPage({super.key, required this.historyItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text(
          historyItem.workoutName,
          style: AppTextStyle.appbarHeading.copyWith(fontSize: 16.sp),
        ),
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
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date
            Text(
              historyItem.dateTime,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp),
            ),
            SizedBox(height: 8.h),
            // Notes
            if (historyItem.notes.isNotEmpty)
              Text(
                historyItem.notes,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13.sp,
                ),
              ),

            SizedBox(height: 20.h),

            // Detail Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF13131F),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF2E2E5D)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: historyItem.exercises.map((exercise) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Exercise Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              exercise.name,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '1 Rm',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        // Sets Rows
                        ...exercise.sets.map(
                          (set) => Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  set.weightAndReps,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: 13.sp,
                                  ),
                                ),
                                Text(
                                  set.oneRm,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
