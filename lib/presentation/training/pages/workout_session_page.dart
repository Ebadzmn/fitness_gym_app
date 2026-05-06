import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/presentation/training/controllers/previous_workout_modal_controller.dart';
import 'package:fitness_app/presentation/training/controllers/workout_session_controller.dart';
import 'package:fitness_app/presentation/training/widgets/workout_history_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_app/features/training/presentation/bloc/timer_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutSessionPage extends StatelessWidget {
  final String planId;
  const WorkoutSessionPage({super.key, required this.planId});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(
      sl<WorkoutSessionController>(),
      tag: planId,
    );

    // Load session if not already loaded
    if (controller.plan.value == null) {
      controller.loadWorkoutSession(planId);
    }

    return BlocProvider(
      create: (context) => TimerBloc(),
      child: Scaffold(
        backgroundColor: AppColor.primaryColor,
        resizeToAvoidBottomInset: true,
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
        title: Obx(() {
          if (controller.plan.value == null) return const Text('Loading...');
          return Column(
            children: [
              Text(
                controller.plan.value!.title,
                style: AppTextStyle.appbarHeading.copyWith(fontSize: 16.sp),
              ),
              Text(
                '${controller.sessionExercises.length} Exercises',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ),
            ],
          );
        }),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
              if (controller.plan.value == null) return;
              Get.delete<PreviousWorkoutModalController>(
                tag: controller.plan.value!.title,
              );
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                showDragHandle: true,
                backgroundColor: const Color(0XFF101021),
                builder: (context) =>
                    WorkoutHistoryModal(planTitle: controller.plan.value!.title),
              );
            },
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          );
        }

        final exercises = controller.sessionExercises;

        return Column(
          children: [
            _TimerSection(planId: planId),
            SizedBox(height: 10.h),
            Expanded(
              child: exercises.isEmpty
                  ? Center(
                      child: Text(
                        'No exercises in this plan',
                        style: GoogleFonts.poppins(color: Colors.white54),
                      ),
                    )
                  : ListView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Exercises',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Obx(() => OutlinedButton.icon(
                                  onPressed: controller.isChangingExercise.value
                                      ? null
                                      : () => controller.changeExercise(
                                            exercises,
                                            context,
                                            (items) => _showExercisePicker(
                                                context, items),
                                          ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Color(0xFF4CAF50),
                                    ),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 8.h,
                                    ),
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  icon: controller.isChangingExercise.value
                                      ? SizedBox(
                                          width: 14.w,
                                          height: 14.w,
                                          child: const CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Color(0xFF4CAF50),
                                          ),
                                        )
                                      : const Icon(Icons.swap_horiz, size: 16),
                                  label: Text(
                                    controller.isChangingExercise.value
                                        ? 'Loading...'
                                        : 'Change Exercise',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        ...List.generate(exercises.length, (index) {
                          final exercise = exercises[index];
                          return _ExerciseRow(
                            exercise: exercise,
                            index: index,
                            planId: planId,
                          );
                        }),
                        SizedBox(height: 8.h),
                        _NotesInput(controller: controller.noteController),
                        SizedBox(height: 24.h),
                        _BottomButtons(
                          onComplete: () => controller.onComplete(),
                          isSaving: controller.isSaving.value,
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
            ),
          ],
        );
      }),
    ),
  );
}

  Future<dynamic> _showExercisePicker(
    BuildContext context,
    List<dynamic> exercises,
  ) {
    return showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: const Color(0XFF101021),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (bottomSheetContext) {
        final searchController = TextEditingController();
        var selectedExercise = exercises.isNotEmpty ? exercises.first : null;

        return StatefulBuilder(
          builder: (context, setModalState) {
            final query = searchController.text.trim().toLowerCase();
            final filtered = exercises.where((item) {
              final title = (item.title ?? '').toString().toLowerCase();
              return title.contains(query);
            }).toList();

            return Padding(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: 16.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
              ),
              child: SizedBox(
                height: 0.75.sh,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Change Exercise',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF13131F),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: const Color(0xFF2E2E5D)),
                      ),
                      child: TextField(
                        controller: searchController,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13.sp,
                        ),
                        onChanged: (_) => setModalState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Search exercise...',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.white38,
                            fontSize: 12.sp,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white54,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Text(
                                'No exercise found',
                                style: GoogleFonts.poppins(
                                  color: Colors.white54,
                                  fontSize: 13.sp,
                                ),
                              ),
                            )
                          : ListView.separated(
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) =>
                                  Divider(color: Colors.white12, height: 1.h),
                              itemBuilder: (context, index) {
                                final item = filtered[index];
                                final isSelected =
                                    item.id?.toString() ==
                                    selectedExercise?.id?.toString();

                                return ListTile(
                                  onTap: () {
                                    setModalState(() {
                                      selectedExercise = item;
                                    });
                                  },
                                  title: Text(
                                    item.title?.toString() ?? '-',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                  subtitle: Text(
                                    item.category?.toString() ?? '',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white60,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                  trailing: Icon(
                                    isSelected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_unchecked,
                                    color: isSelected
                                        ? const Color(0xFF4CAF50)
                                        : Colors.white38,
                                  ),
                                );
                              },
                            ),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: selectedExercise == null
                            ? null
                            : () => Navigator.of(
                                bottomSheetContext,
                              ).pop(selectedExercise),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          disabledBackgroundColor: Colors.white24,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: Text(
                          'Change Exercise',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _TimerSection extends StatelessWidget {
  final String planId;
  const _TimerSection({required this.planId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkoutSessionController>(tag: planId);
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        final d = state.duration;
        final hours = (d ~/ 3600).toString().padLeft(2, '0');
        final minutes = ((d % 3600) ~/ 60).toString().padLeft(2, '0');
        final seconds = (d % 60).toString().padLeft(2, '0');
        final isRunning = state.isRunning;

        // Sync back to controller for submission
        controller.duration.value = d;
        controller.isTimerRunning.value = isRunning;

        return Column(
          children: [
            Text(
              isRunning ? 'Running...' : 'Start!',
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
                  _timerItem(hours, 'hours'),
                  _divider(),
                  _timerItem(minutes, 'Minutes'),
                  _divider(),
                  _timerItem(seconds, 'seconds'),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (isRunning) {
                      context.read<TimerBloc>().add(PauseTimer());
                    } else {
                      context.read<TimerBloc>().add(StartTimer());
                    }
                  },
                  borderRadius: BorderRadius.circular(30.r),
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF2E5B24),
                        width: 1.w,
                      ),
                    ),
                    child: Icon(
                      isRunning
                          ? Icons.pause_circle_outline
                          : Icons.play_circle_outline,
                      color: const Color(0xFF2E5B24),
                      size: 32.sp,
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                InkWell(
                  onTap: () {
                    context.read<TimerBloc>().add(ResetTimer());
                  },
                  borderRadius: BorderRadius.circular(30.r),
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.red.withOpacity(0.5),
                        width: 1.w,
                      ),
                    ),
                    child: Icon(
                      Icons.refresh,
                      color: Colors.red.withOpacity(0.8),
                      size: 32.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
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

class _ExerciseRow extends StatelessWidget {
  final TrainingPlanExerciseEntity exercise;
  final int index;
  final String planId;

  const _ExerciseRow({
    required this.exercise,
    required this.index,
    required this.planId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkoutSessionController>(tag: planId);

    return Obx(() {
      final isCompleted = controller.completedExercises[index] ?? false;
      return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: const Color(0xFF13131F),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isCompleted
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFF2E2E5D),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      exercise.name,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '${exercise.sets ?? '-'} Sets',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 40.w,
                          child: Text(
                            'Set',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'Weight',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'Reps',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'RIR',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () => controller.toggleExerciseCompletion(index),
                          child: Icon(
                            isCompleted
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            color: isCompleted
                                ? const Color(0xFF4CAF50)
                                : Colors.white24,
                            size: 22.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Column(
                      children: List.generate(
                          controller.exerciseControllers[index]?.length ?? 0,
                          (sIndex) {
                        final setControllers =
                            controller.exerciseControllers[index]![sIndex];
                        final setsDetail = (exercise.exerciseSets as List?) ?? const [];
                        final setModel =
                            setsDetail.length > sIndex ? setsDetail[sIndex] : null;
                        final setLabel =
                            setModel != null ? setModel.sets.toString() : '${sIndex + 1}';
                        final repsHint = setModel != null
                            ? setModel.repRange.toString()
                            : (exercise.range ?? '');
                        final rirHint = setModel != null
                            ? setModel.rir.toString()
                            : (exercise.rir ?? '');

                        final errorMap = controller.fieldErrors[index]![sIndex];

                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 40.w,
                                child: Text(
                                  setLabel,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              _inputBox(
                                setControllers['weight'],
                                hintText: '',
                                isError: errorMap['weight']!.value,
                              ),
                              SizedBox(width: 8.w),
                              _inputBox(
                                setControllers['reps'],
                                hintText: repsHint,
                                isError: errorMap['reps']!.value,
                              ),
                              SizedBox(width: 8.w),
                              _inputBox(
                                setControllers['rir'],
                                hintText: rirHint,
                                isError: errorMap['rir']!.value,
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
    });
  }

  Widget _inputBox(
    TextEditingController? controller, {
    String hintText = '',
    bool isError = false,
  }) {
    return Expanded(
      child: Container(
        height: 45.h,
        decoration: BoxDecoration(
          color: const Color(0XFF101021),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isError ? Colors.red : const Color(0xFF2E2E5D),
          ),
        ),
        child: TextFormField(
          controller: controller,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(
              color: Colors.white38,
              fontSize: 10.sp,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }
}

class _NotesInput extends StatelessWidget {
  final TextEditingController controller;
  const _NotesInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF13131F),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFF2E2E5D)),
          ),
          child: TextField(
            controller: controller,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp),
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Add your workout notes here...',
              hintStyle: GoogleFonts.poppins(
                color: Colors.white30,
                fontSize: 14.sp,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomButtons extends StatelessWidget {
  final VoidCallback onComplete;
  final bool isSaving;
  const _BottomButtons({required this.onComplete, required this.isSaving});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              side: const BorderSide(color: Color(0xFF2E2E5D)),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
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
        SizedBox(width: 16.w),
        Expanded(
          child: ElevatedButton(
            onPressed: isSaving ? null : onComplete,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: isSaving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Complete',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
