import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/domain/usecases/checkin/get_checkin_history_usecase.dart';
import 'package:fitness_app/presentation/checkIn/widgets/checkIn_widgets.dart';
import 'package:fitness_app/presentation/checkIn/widgets/questions_tab.dart';
import 'package:fitness_app/presentation/checkIn/widgets/checking_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/core/coreWidget/full_width_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/data/repositories/fake_checkin_repository.dart';
import 'package:fitness_app/domain/usecases/checkin/get_checkin_initial_usecase.dart';
import 'package:fitness_app/domain/usecases/checkin/save_checkin_usecase.dart';
import 'package:fitness_app/domain/usecases/checkin/get_checkin_history_usecase.dart';
import 'package:fitness_app/presentation/checkIn/bloc/checkin_bloc.dart';
import 'package:fitness_app/presentation/checkIn/bloc/checkin_event.dart';
import 'package:fitness_app/presentation/checkIn/bloc/checkin_state.dart';
import 'package:fitness_app/domain/entities/checkin_entities/check_in_entity.dart';

class CheckinPages extends StatelessWidget {
  const CheckinPages({super.key});
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => FakeCheckInRepository(),
      child: Builder(
        builder: (ctx) {
          final repo = RepositoryProvider.of<FakeCheckInRepository>(ctx);
          return BlocProvider(
            create: (_) => CheckInBloc(
              getInitial: GetCheckInInitialUseCase(repo),
              saveCheckIn: SaveCheckInUseCase(repo),
              getHistory: GetCheckInHistoryUseCase(repo),
            )..add(const CheckInInitRequested()),
            child: const _CheckInView(),
          );
        },
      ),
    );
  }
}

class _CheckInView extends StatelessWidget {
  const _CheckInView();
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
      body: BlocConsumer<CheckInBloc, CheckInState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status == CheckInStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Error')),
            );
          }
          if (state.status == CheckInStatus.saved) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Submitted')));
          }
        },
        builder: (context, state) {
          if (state.status == CheckInStatus.loading || state.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final step = state.data!.step;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => context.read<CheckInBloc>().add(
                        const CheckInStepSet(0),
                      ),
                      child: CheckInStep(
                        icon: Icons.person_outline,
                        label: "Profile",
                        isActive: step == 0,
                        isCompleted: step > 0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.read<CheckInBloc>().add(
                        const CheckInStepSet(1),
                      ),
                      child: CheckInStep(
                        icon: Icons.camera_alt_outlined,
                        label: "Photos",
                        isActive: step == 1,
                        isCompleted: step > 1,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.read<CheckInBloc>().add(
                        const CheckInStepSet(2),
                      ),
                      child: CheckInStep(
                        icon: Icons.chat_bubble_outline,
                        label: "Questions",
                        isActive: step == 2,
                        isCompleted: step > 2,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.read<CheckInBloc>().add(
                        const CheckInStepSet(3),
                      ),
                      child: CheckInStep(
                        icon: Icons.check_circle_outline,
                        label: "Checking",
                        isActive: step == 3,
                        isCompleted: step > 3,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),

                // Tabs: Weekly Check-In / Old Check-In
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F0F15),
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(color: const Color(0xFF2E2E5D)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.read<CheckInBloc>().add(const CheckInTabSet('weekly')),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                              color: state.tab == CheckInViewTab.weekly ? const Color(0xFF446B36) : Colors.transparent,
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Weekly Check-In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.read<CheckInBloc>().add(const CheckInTabSet('old')),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                              color: state.tab == CheckInViewTab.old ? const Color(0xFF446B36) : Colors.transparent,
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Old Check-In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // Old Check-In view uses history navigation, Weekly shows only date info (no step prev/next)
                if (state.tab == CheckInViewTab.old) ...[
                  _oldList(context, state.history, state.historyIndex),
                ] else ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 20.w,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFF1B2B1B,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFF2E4E2E)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Check-in Date: 12 March 2025',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            'Day: Wednesday',
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: 30.h),

                if (state.tab == CheckInViewTab.weekly) _bodyForStep(step),

                // Bottom Buttons
                if (state.tab == CheckInViewTab.weekly && step == 0) ...[
                  SizedBox(height: 40.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.read<CheckInBloc>().add(
                            const CheckInNextPressed(),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFF446B36,
                            ), // Green for Next
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'Next',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else if (state.tab == CheckInViewTab.weekly && step == 3) ...[
                  SizedBox(height: 40.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.read<CheckInBloc>().add(
                            const SubmitPressed(),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF446B36),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ], // Close Column children
            ),
          );
        },
      ),
    );
  }

  Widget _oldList(
    BuildContext context,
    List<CheckInEntity> items,
    int index,
  ) {
    if (items.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF101021),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            const Icon(Icons.history, color: Colors.white70),
            SizedBox(width: 12.w),
            const Expanded(
              child: Text('No previous check-ins found', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      );
    }
    final safeIndex = index.clamp(0, items.length - 1);
    final current = items[safeIndex];
    final weekLabel = current.weekId ?? '-';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF101021),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Week starting $weekLabel',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                '${safeIndex + 1} of ${items.length}',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: safeIndex < items.length - 1
                    ? () => context.read<CheckInBloc>().add(const CheckInHistoryPrev())
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C222E),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Previous',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton(
                onPressed: safeIndex > 0
                    ? () => context.read<CheckInBloc>().add(const CheckInHistoryNext())
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF446B36),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        CheckInCard(
          title: 'Energy ${current.wellBeing.energy.round()} • Diet ${current.nutrition.dietLevel.round()}',
          value: 'Week starting $weekLabel',
          icon: Icons.history,
          showBadge: false,
        ),
      ],
    );
  }

  Widget _bodyForStep(int step) {
    if (step == 0) {
      return Column(
        children: const [
          Row(
            children: [
              Icon(Icons.monitor_weight_outlined, color: Colors.white),
              SizedBox(width: 8),
              Text(
                "Basic Data",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          CheckInCard(
            title: "competition class",
            value: "Classic Physique",
            icon: Icons.emoji_events_outlined,
          ),
          CheckInCard(
            title: "Current Weight (kg)",
            value: "80.2 (kg)",
            showBadge: true,
          ),
          CheckInCard(
            title: "Average Weight in %",
            value: "80.2 (%)",
            showBadge: true,
          ),
        ],
      );
    } else if (step == 1) {
      return Column(
        children: [
          InstructionText(
            icon: Icons.description_outlined,
            text:
                "You Can Select Multiple Files, But At Least One File Must Be Chosen",
          ),
          SizedBox(height: 16.h),
          FileUploadWidget(label: "Select File", onTap: () {}),
          SizedBox(height: 24.h),
          InstructionText(
            icon: Icons.play_circle_outline,
            text:
                "Only One Video Can Be Uploaded, And The Maximum File Size Is 500 MB.",
          ),
          SizedBox(height: 16.h),
          VideoUploadWidget(label: "Drag & drop video file", onTap: () {}),
        ],
      );
    } else if (step == 2) {
      return const QuestionsTab();
    } else if (step == 3) {
      return const CheckingTab();
    }
    return Container();
  }
}
