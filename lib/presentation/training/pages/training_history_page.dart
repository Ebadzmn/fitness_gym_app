import 'package:fitness_app/core/appRoutes/app_routes.dart';

import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/domain/entities/training_entities/training_history_entity.dart';
import 'package:fitness_app/features/training/data/repositories/fake_training_history_repository.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_history_usecase.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_history/training_history_bloc.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_history/training_history_event.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_history/training_history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingHistoryPage extends StatelessWidget {
  const TrainingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => FakeTrainingHistoryRepository(),
      child: Builder(
        builder: (ctx) {
          final repo = RepositoryProvider.of<FakeTrainingHistoryRepository>(
            ctx,
          );
          return BlocProvider(
            create: (_) =>
                TrainingHistoryBloc(getHistory: GetTrainingHistoryUseCase(repo))
                  ..add(const TrainingHistoryLoadRequested()),
            child: const _TrainingHistoryView(),
          );
        },
      ),
    );
  }
}

class _TrainingHistoryView extends StatelessWidget {
  const _TrainingHistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text('Training History', style: AppTextStyle.appbarHeading),
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
      body: BlocBuilder<TrainingHistoryBloc, TrainingHistoryState>(
        builder: (context, state) {
          if (state.status == TrainingHistoryStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == TrainingHistoryStatus.failure) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }
          if (state.history.isEmpty) {
            return const Center(
              child: Text(
                "No history available",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: state.history.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              return _HistoryCard(item: state.history[index]);
            },
          );
        },
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final TrainingHistoryEntity item;

  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          context.push(AppRoutes.trainingHistoryDetailPage, extra: item),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF13131F),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF2E2E5D)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Month | Workouts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.month,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${item.workoutCount} Workouts',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Workout Title & Date
            Text(
              item.workoutName,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              item.dateTime,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 12.h),

            // Sets Label
            Text.rich(
              TextSpan(
                text: 'Sets / Bestes Set ',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13.sp,
                ),
                children: [
                  TextSpan(
                    text: '→ Best Set',
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),

            // Exercises List
            ...item.exercises
                .take(3)
                .map(
                  (e) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Text(
                      '${e.sets.length} x ${e.name} → ${e.bestSetDisplay}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13.sp,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),

            SizedBox(height: 16.h),

            // Stats Row
            Row(
              children: [
                _statItem(Icons.access_time_filled, item.duration),
                SizedBox(width: 20.w),
                _statItem(Icons.monitor_weight_outlined, item.volume),
                SizedBox(width: 20.w),
                _statItem(
                  Icons.emoji_events_outlined,
                  item.prs,
                  iconColor: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(IconData icon, String label, {Color? iconColor}) {
    return Row(
      children: [
        Icon(icon, color: iconColor ?? Colors.white70, size: 18.sp),
        SizedBox(width: 6.w),
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13.sp),
        ),
      ],
    );
  }
}
