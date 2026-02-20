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
import 'package:fitness_app/features/training/data/models/training_history_request_model.dart';
import 'package:fitness_app/injection_container.dart';

class WorkoutSessionPage extends StatefulWidget {
  final String planId;
  const WorkoutSessionPage({super.key, required this.planId});

  @override
  State<WorkoutSessionPage> createState() => _WorkoutSessionPageState();
}

class _WorkoutSessionPageState extends State<WorkoutSessionPage> {
  final Map<int, List<Map<String, TextEditingController>>> _exerciseControllers =
      {};
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    for (var list in _exerciseControllers.values) {
      for (var controllers in list) {
        for (var c in controllers.values) {
          c.dispose();
        }
      }
    }
    _noteController.dispose();
    super.dispose();
  }

  void _initializeControllers(List<dynamic> exercises) {
    for (int i = 0; i < exercises.length; i++) {
      final exercise = exercises[i];
      final setsDetail = (exercise.exerciseSets as List?) ?? const [];
      final setsCount = setsDetail.isNotEmpty ? setsDetail.length : 1;

      final existing = _exerciseControllers[i];
      if (existing != null && existing.length == setsCount) {
        continue;
      }

      final oldList = _exerciseControllers[i];
      if (oldList != null) {
        for (var map in oldList) {
          for (var c in map.values) {
            c.dispose();
          }
        }
      }

      _exerciseControllers[i] = List.generate(setsCount, (setIndex) {
        final setModel =
            setsDetail.isNotEmpty ? setsDetail[setIndex] : null;
        final repTemplate = setModel != null
            ? (setModel.repRange?.toString() ?? '')
            : (exercise.rep ?? exercise.range ?? '');
        final rirTemplate = setModel != null
            ? (setModel.rir?.toString() ?? '')
            : (exercise.rir ?? '');

        return {
          'weight': TextEditingController(),
          'reps': TextEditingController(text: repTemplate),
          'rir': TextEditingController(text: rirTemplate),
        };
      });
    }
  }

  void _onComplete(BuildContext context, dynamic plan, int duration) {
    final List<PushData> pushData = [];
    final exercises = plan.exercises;

    for (int i = 0; i < exercises.length; i++) {
      final exercise = exercises[i];
      final setsDetail = (exercise.exerciseSets as List?) ?? const [];
      final controllersList = _exerciseControllers[i];

      if (controllersList == null || controllersList.isEmpty) {
        continue;
      }

      if (setsDetail.isEmpty) {
        final controllers = controllersList.first;
        final weight =
            num.tryParse(controllers['weight']?.text ?? '0') ?? 0;
        final repRange = controllers['reps']?.text ?? '';
        final rir = controllers['rir']?.text ?? '';

        pushData.add(
          PushData(
            weight: weight,
            repRange: repRange,
            rir: rir,
            set: 1,
            exerciseName: exercise.name,
          ),
        );
      } else {
        final count = setsDetail.length;
        for (int s = 0; s < count; s++) {
          final controllers = controllersList.length > s
              ? controllersList[s]
              : controllersList.last;
          final setModel = setsDetail[s];
          final weight =
              num.tryParse(controllers['weight']?.text ?? '0') ?? 0;
          final userRep = controllers['reps']?.text ?? '';
          final userRir = controllers['rir']?.text ?? '';
          final repRange = userRep.isNotEmpty
              ? userRep
              : (setModel.repRange?.toString() ?? '');
          final rir = userRir.isNotEmpty
              ? userRir
              : (setModel.rir?.toString() ?? '');
          final setNumber =
              int.tryParse(setModel.sets?.toString() ?? '') ?? (s + 1);

          pushData.add(
            PushData(
              weight: weight,
              repRange: repRange,
              rir: rir,
              set: setNumber,
              exerciseName: exercise.name,
            ),
          );
        }
      }
    }

    final hours = (duration ~/ 3600).toString();
    final minutes = ((duration % 3600) ~/ 60).toString();

    context.read<WorkoutSessionCubit>().saveSession(
      trainingName: plan.title,
      time: TrainingTime(hour: hours, minite: minutes),
      pushData: pushData,
      note: _noteController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<WorkoutSessionCubit>()..loadWorkoutSession(widget.planId),
      child: BlocListener<WorkoutSessionCubit, WorkoutSessionState>(
        listener: (context, state) {
          if (state is WorkoutSessionSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Workout saved successfully!')),
            );
            context.pop();
          }
          if (state is WorkoutSessionError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
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
              _initializeControllers(exercises);

              return BlocProvider(
                create: (context) => WorkoutTimerCubit(),
                child: Builder(
                  builder: (context) {
                    return Scaffold(
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
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            controllers:
                                                _exerciseControllers[index]!,
                                          ),

                                          if (index ==
                                              exercises.length - 1) ...[
                                            SizedBox(height: 20.h),
                                            _NotesInput(
                                              controller: _noteController,
                                            ),
                                            SizedBox(height: 24.h),
                                            _BottomButtons(
                                              onComplete: () {
                                                final duration = context
                                                    .read<WorkoutTimerCubit>()
                                                    .state
                                                    .duration;
                                                _onComplete(
                                                  context,
                                                  plan,
                                                  duration,
                                                );
                                              },
                                            ),
                                            SizedBox(height: 20.h),
                                          ],
                                        ],
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
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
  final List<Map<String, TextEditingController>> controllers;

  const _ExerciseRow({
    required this.exercise,
    required this.index,
    required this.controllers,
  });

  @override
  State<_ExerciseRow> createState() => _ExerciseRowState();
}

class _ExerciseRowState extends State<_ExerciseRow> {
  bool isCompleted = false;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.exercise.name,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${widget.exercise.sets ?? '-'} Sets',
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
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isCompleted = !isCompleted;
                        });
                      },
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
                  children: List.generate(widget.controllers.length, (index) {
                    final setControllers = widget.controllers[index];
                    final setsDetail =
                        (widget.exercise.exerciseSets as List?) ?? const [];
                    final setModel =
                        setsDetail.length > index ? setsDetail[index] : null;
                    final setLabel = setModel != null &&
                            (setModel.sets?.toString().isNotEmpty ?? false)
                        ? setModel.sets.toString()
                        : '${index + 1}';

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
                            '',
                            setControllers['weight'],
                            isEditable: true,
                          ),
                          SizedBox(width: 8.w),
                          _inputBox(
                            '',
                            setControllers['reps'],
                            isEditable: true,
                          ),
                          SizedBox(width: 8.w),
                          _inputBox(
                            '',
                            setControllers['rir'],
                            isEditable: true,
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
  const _BottomButtons({required this.onComplete});

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
            onPressed: onComplete,
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
