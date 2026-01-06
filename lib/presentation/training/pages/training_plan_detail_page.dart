import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_plan_by_id_usecase.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_plan_detail/training_plan_detail_cubit.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_plan_detail/training_plan_detail_state.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingPlanDetailPage extends StatelessWidget {
  final String planId;

  const TrainingPlanDetailPage({super.key, required this.planId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrainingPlanDetailCubit(
        getTrainingPlanById: sl<GetTrainingPlanByIdUseCase>(),
      )..loadTrainingPlanDetail(planId),
      child: Scaffold(
        backgroundColor: AppColor.primaryColor,
        appBar: AppBar(
          title: Text('Training Plan', style: AppTextStyle.appbarHeading),
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
        body: BlocBuilder<TrainingPlanDetailCubit, TrainingPlanDetailState>(
          builder: (context, state) {
            if (state is TrainingPlanDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TrainingPlanDetailError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (state is TrainingPlanDetailLoaded) {
              return _PlanDetailContent(plan: state.plan);
            }
            // Initial state or fallback
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class _PlanDetailContent extends StatelessWidget {
  final TrainingPlanEntity plan;

  const _PlanDetailContent({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF13131F), // Dark card background
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFF2E2E5D)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  plan.subtitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                if (plan.exercises.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Center(
                      child: Text(
                        "No exercises in this plan",
                        style: GoogleFonts.poppins(color: Colors.white54),
                      ),
                    ),
                  )
                else
                  ...plan.exercises.map((e) => _ExerciseItem(exercise: e)),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {
                context.push(AppRoutes.WorkoutSessionPage, extra: plan.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F123B), // Dark blue button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(color: const Color(0xFF2E2E8D)),
                ),
              ),
              child: Text(
                'Workout Beginner',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

class _ExerciseItem extends StatelessWidget {
  final TrainingPlanExerciseEntity exercise;

  const _ExerciseItem({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: const Color(0xFFEFA9A9), // Light Pink color
            child: Text(
              exercise.name.isNotEmpty
                  ? exercise.name.substring(0, 1).toUpperCase()
                  : '?',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${exercise.sets} x ${exercise.name}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  exercise.muscle ?? '',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
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
