import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/workout_timer/workout_timer_cubit.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/workout_timer/workout_timer_state.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/workout_session/workout_session_cubit.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/workout_session/workout_session_state.dart';
import 'package:fitness_app/injection_container.dart';

class WorkoutSessionPage extends StatefulWidget {
  final String planId;
  const WorkoutSessionPage({super.key, required this.planId});

  @override
  State<WorkoutSessionPage> createState() => _WorkoutSessionPageState();
}

class _WorkoutSessionPageState extends State<WorkoutSessionPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<WorkoutSessionCubit>()..loadWorkoutSession(widget.planId),
      child: BlocBuilder<WorkoutSessionCubit, WorkoutSessionState>(
        builder: (context, state) {
          if (state is WorkoutSessionLoading) {
            return const Scaffold(
              backgroundColor: AppColor.primaryColor,
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
              ),
            );
          }
          if (state is WorkoutSessionError) {
            return Scaffold(
              backgroundColor: AppColor.primaryColor,
              body: Center(
                child: Text(
                  state.message,
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            );
          }
          if (state is WorkoutSessionLoaded) {
            final plan = state.plan;
            final exercises = plan.exercises;
            return BlocProvider(
              create: (context) => WorkoutTimerCubit(),
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
                  title: Column(
                    children: [
                      Text(
                        plan.title,
                        style: AppTextStyle.appbarHeading.copyWith(
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        '${exercises.length} Exercises',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  centerTitle: true,
                ),
                body: Column(
                  children: [
                    const _TimerSection(),
                    SizedBox(height: 10.h),
                    Expanded(
                      child: exercises.isEmpty
                          ? Center(
                              child: Text(
                                'No exercises in this plan',
                                style: GoogleFonts.poppins(
                                  color: Colors.white54,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 10.h,
                              ),
                              itemCount: exercises.length,
                              itemBuilder: (context, index) {
                                final exercise = exercises[index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (index == 0) ...[
                                      Text(
                                        'Exercises',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 12.h),
                                    ],
                                    _ExerciseRow(
                                      exercise: exercise,
                                      index: index + 1,
                                    ),

                                    if (index == exercises.length - 1) ...[
                                      SizedBox(height: 20.h),
                                      const _NotesInput(),
                                      SizedBox(height: 24.h),
                                      const _BottomButtons(),
                                      SizedBox(height: 20.h),
                                    ],
                                  ],
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _TimerSection extends StatelessWidget {
  const _TimerSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutTimerCubit, WorkoutTimerState>(
      builder: (context, state) {
        final hours = (state.duration ~/ 3600).toString().padLeft(2, '0');
        final minutes = ((state.duration % 3600) ~/ 60).toString().padLeft(
          2,
          '0',
        );
        final seconds = (state.duration % 60).toString().padLeft(2, '0');

        return Column(
          children: [
            Text(
              state.isRunning ? 'Running...' : 'Start!',
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
            // Play/Pause button
            InkWell(
              onTap: () {
                context.read<WorkoutTimerCubit>().toggleTimer();
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
                  state.isRunning
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline,
                  color: const Color(0xFF2E5B24),
                  size: 32.sp,
                ),
              ),
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

class _ExerciseRow extends StatefulWidget {
  final dynamic exercise;
  final int index;

  const _ExerciseRow({required this.exercise, required this.index});

  @override
  State<_ExerciseRow> createState() => _ExerciseRowState();
}

class _ExerciseRowState extends State<_ExerciseRow> {
  late TextEditingController weightController;
  late TextEditingController repsController;
  late TextEditingController setsController;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    weightController = TextEditingController();
    repsController = TextEditingController(text: widget.exercise.rep ?? '');
    setsController = TextEditingController(text: widget.exercise.sets ?? '');
  }

  @override
  void dispose() {
    weightController.dispose();
    repsController.dispose();
    setsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          Text(
            widget.exercise.name,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              // Badge showing Range
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? const Color(0x4D2E5B24)
                      : const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isCompleted
                        ? const Color(0xFF2E5B24)
                        : Colors.white10,
                  ),
                ),
                child: Text(
                  widget.exercise.range ?? '-',
                  style: GoogleFonts.poppins(
                    color: isCompleted
                        ? const Color(0xFF4CAF50)
                        : Colors.white60,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              _inputBox('Weight', weightController, isEditable: true),
              SizedBox(width: 8.w),
              _inputBox('Reps', repsController, isEditable: true),
              SizedBox(width: 8.w),
              _inputBox('Sets', setsController, isEditable: true),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isCompleted = !isCompleted;
                  });
                },
                child: Icon(
                  isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                  color: isCompleted ? const Color(0xFF4CAF50) : Colors.white24,
                  size: 26.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _inputBox(
    String label,
    TextEditingController? controller, {
    String value = '',
    bool isEditable = false,
  }) {
    return Expanded(
      child: Container(
        height: 45.h,
        decoration: BoxDecoration(
          color: const Color(0XFF101021),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFF2E2E5D)),
        ),
        child: isEditable
            ? TextFormField(
                controller: controller,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 10.sp,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
  const _BottomButtons();

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
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
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
      ],
    );
  }
}
