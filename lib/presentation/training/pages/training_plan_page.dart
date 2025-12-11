import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';
import 'package:fitness_app/features/training/data/repositories/fake_training_plan_repository.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_plans_usecase.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_plan/training_plan_bloc.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_plan/training_plan_event.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_plan/training_plan_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingPlanPage extends StatelessWidget {
  const TrainingPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => FakeTrainingPlanRepository(),
      child: Builder(
        builder: (ctx) {
          final repo = RepositoryProvider.of<FakeTrainingPlanRepository>(ctx);
          return BlocProvider(
            create: (_) => TrainingPlanBloc(
              getTrainingPlans: GetTrainingPlansUseCase(repo),
            )..add(const TrainingPlanLoadRequested()),
            child: const _TrainingPlanView(),
          );
        },
      ),
    );
  }
}

class _TrainingPlanView extends StatelessWidget {
  const _TrainingPlanView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: BlocBuilder<TrainingPlanBloc, TrainingPlanState>(
        builder: (context, state) {
          if (state.status == TrainingPlanStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == TrainingPlanStatus.failure) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }

          return GridView.builder(
            padding: EdgeInsets.all(16.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.8,
            ),
            itemCount: state.plans.length,
            itemBuilder: (context, index) {
              return _TrainingPlanCard(plan: state.plans[index]);
            },
          );
        },
      ),
    );
  }
}

class _TrainingPlanCard extends StatelessWidget {
  final TrainingPlanEntity plan;

  const _TrainingPlanCard({required this.plan});

  Color _getBorderColor(String title) {
    // Attempting to match colors from screenshot based on title or just alternating
    // The screenshot has green and blueish borders.
    if (title.contains('PLACEHOLDER') || title.contains('PUSH FULLBODY')) {
      return const Color(0xFF2E5B24); // Dark Greenish
    }
    return const Color(0xFF09579A); // Blueish
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(AppRoutes.trainingPlanDetailPage, extra: plan),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0XFF101021),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: _getBorderColor(plan.title).withOpacity(0.5),
            width: 1.w,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              plan.title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              plan.subtitle,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.access_time_filled,
                  color: Colors.white,
                  size: 16.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  plan.date,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
