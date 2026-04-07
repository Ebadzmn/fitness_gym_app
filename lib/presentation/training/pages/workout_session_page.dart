import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';
import 'package:fitness_app/features/training/data/models/training_history_request_model.dart';
import 'package:fitness_app/features/training/domain/repositories/exercise_repository.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/workout_session/workout_session_cubit.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/workout_session/workout_session_state.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/workout_timer/workout_timer_cubit.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/workout_timer/workout_timer_state.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/presentation/training/controllers/previous_workout_modal_controller.dart';
import 'package:fitness_app/presentation/training/widgets/workout_history_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutSessionPage extends StatefulWidget {
  final String planId;
  const WorkoutSessionPage({super.key, required this.planId});

  @override
  State<WorkoutSessionPage> createState() => _WorkoutSessionPageState();
}

class _WorkoutSessionPageState extends State<WorkoutSessionPage> {
  final Map<int, List<Map<String, TextEditingController>>>
  _exerciseControllers = {};
  final Map<int, List<Map<String, bool>>> _fieldErrors = {};
  final TextEditingController _noteController = TextEditingController();

  String? _planKey;
  bool _hasLoadedFromPrefs = false;
  bool _isChangingExercise = false;
  List<TrainingPlanExerciseEntity>? _sessionExercises;

  @override
  void initState() {
    super.initState();
    _noteController.addListener(_onNoteChanged);
  }

  @override
  void dispose() {
    for (final list in _exerciseControllers.values) {
      for (final controllers in list) {
        for (final c in controllers.values) {
          c.dispose();
        }
      }
    }
    _fieldErrors.clear();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _onChangeExercisePressed(
    BuildContext context,
    List<TrainingPlanExerciseEntity> currentExercises,
  ) async {
    if (_isChangingExercise) return;

    setState(() {
      _isChangingExercise = true;
    });

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
      ),
    );

    final repo = sl<ExerciseRepository>();
    final result = await repo.getExercises();

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    if (!mounted) return;

    setState(() {
      _isChangingExercise = false;
    });

    await result.fold(
      (failure) async {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      },
      (items) async {
        if (!mounted) return;

        final selected = await _showExercisePicker(context, items);
        if (selected == null || !mounted) return;

        final newExercise = TrainingPlanExerciseEntity(
          name: selected.title,
          sets: '1',
          muscle: selected.category,
          type: selected.equipment,
          range: '',
          rir: '',
          exerciseSets: const [],
        );

        setState(() {
          final next = List<TrainingPlanExerciseEntity>.from(currentExercises)
            ..add(newExercise);
          _sessionExercises = next;
          _initializeControllers(next);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${selected.title} added to workout.')),
        );
      },
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

  String _buildFieldKey(
    String planKey,
    int exerciseIndex,
    int setIndex,
    String field,
  ) {
    return 'workout_${planKey}_ex${exerciseIndex}_set${setIndex}_$field';
  }

  String _buildNoteKey(String planKey) {
    return 'workout_${planKey}_note';
  }

  Future<void> _saveField(
    int exerciseIndex,
    int setIndex,
    String field,
    String value,
  ) async {
    if (_planKey == null) return;
    final prefs = sl<SharedPreferences>();
    final key = _buildFieldKey(_planKey!, exerciseIndex, setIndex, field);
    await prefs.setString(key, value);
  }

  Future<void> _saveNote(String value) async {
    if (_planKey == null) return;
    final prefs = sl<SharedPreferences>();
    final key = _buildNoteKey(_planKey!);
    await prefs.setString(key, value);
  }

  void _onNoteChanged() {
    _saveNote(_noteController.text);
  }

  void _attachControllerListeners(
    int exerciseIndex,
    int setIndex,
    Map<String, TextEditingController> controllers,
  ) {
    controllers['weight']?.addListener(() {
      _saveField(
        exerciseIndex,
        setIndex,
        'weight',
        controllers['weight']?.text ?? '',
      );
    });
    controllers['reps']?.addListener(() {
      _saveField(
        exerciseIndex,
        setIndex,
        'reps',
        controllers['reps']?.text ?? '',
      );
    });
    controllers['rir']?.addListener(() {
      _saveField(
        exerciseIndex,
        setIndex,
        'rir',
        controllers['rir']?.text ?? '',
      );
    });
  }

  Future<void> _loadSavedControllers(List<dynamic> exercises) async {
    if (_planKey == null) return;
    final prefs = sl<SharedPreferences>();

    for (int i = 0; i < exercises.length; i++) {
      final controllersList = _exerciseControllers[i];
      if (controllersList == null) continue;

      for (int setIndex = 0; setIndex < controllersList.length; setIndex++) {
        final map = controllersList[setIndex];

        for (final field in ['weight', 'reps', 'rir']) {
          final key = _buildFieldKey(_planKey!, i, setIndex, field);
          final value = prefs.getString(key);
          if (value != null && value.isNotEmpty) {
            final controller = map[field];
            if (controller != null && controller.text != value) {
              controller.text = value;
            }
          }
        }
      }
    }

    final noteKey = _buildNoteKey(_planKey!);
    final noteValue = prefs.getString(noteKey);
    if (noteValue != null && noteValue.isNotEmpty) {
      if (_noteController.text != noteValue) {
        _noteController.text = noteValue;
      }
    }
  }

  Future<void> _clearSavedControllers(List<dynamic> exercises) async {
    if (_planKey == null) return;
    final prefs = sl<SharedPreferences>();

    for (int i = 0; i < exercises.length; i++) {
      final controllersList = _exerciseControllers[i];
      if (controllersList == null) continue;

      for (int setIndex = 0; setIndex < controllersList.length; setIndex++) {
        for (final field in ['weight', 'reps', 'rir']) {
          final key = _buildFieldKey(_planKey!, i, setIndex, field);
          await prefs.remove(key);
        }
      }
    }

    final noteKey = _buildNoteKey(_planKey!);
    await prefs.remove(noteKey);
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
        for (final map in oldList) {
          for (final c in map.values) {
            c.dispose();
          }
        }
      }

      _exerciseControllers[i] = List.generate(setsCount, (setIndex) {
        final controllers = {
          'weight': TextEditingController(),
          'reps': TextEditingController(),
          'rir': TextEditingController(),
        };
        _attachControllerListeners(i, setIndex, controllers);
        return controllers;
      });

      _fieldErrors[i] = List.generate(setsCount, (_) {
        return {'weight': false, 'reps': false, 'rir': false};
      });
    }
  }

  void _onComplete(
    BuildContext context,
    String trainingName,
    List<TrainingPlanExerciseEntity> exercises,
    int duration,
  ) {
    final List<PushData> pushData = [];

    for (int i = 0; i < exercises.length; i++) {
      final exercise = exercises[i];
      final setsDetail = (exercise.exerciseSets as List?) ?? const [];
      final controllersList = _exerciseControllers[i];

      if (controllersList == null || controllersList.isEmpty) {
        continue;
      }

      if (setsDetail.isEmpty) {
        final controllers = controllersList.first;
        final weight = num.tryParse(controllers['weight']?.text ?? '0') ?? 0;
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
          final controllers =
              controllersList.length > s ? controllersList[s] : controllersList.last;
          final setModel = setsDetail[s];
          final weight = num.tryParse(controllers['weight']?.text ?? '0') ?? 0;
          final userRep = controllers['reps']?.text ?? '';
          final userRir = controllers['rir']?.text ?? '';
          final repRange =
              userRep.isNotEmpty ? userRep : (setModel.repRange?.toString() ?? '');
          final rir = userRir.isNotEmpty ? userRir : (setModel.rir?.toString() ?? '');
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
      trainingName: trainingName,
      time: TrainingTime(hour: hours, minite: minutes),
      pushData: pushData,
      note: _noteController.text,
    );
  }

  bool _validateAllFields(List<dynamic> exercises, BuildContext context) {
    bool hasError = false;

    for (int i = 0; i < exercises.length; i++) {
      final controllersList = _exerciseControllers[i];
      if (controllersList == null || controllersList.isEmpty) {
        hasError = true;
        continue;
      }

      final errorList = _fieldErrors[i] ??
          List.generate(controllersList.length, (_) {
            return {'weight': false, 'reps': false, 'rir': false};
          });

      if (errorList.length != controllersList.length) {
        _fieldErrors[i] = List.generate(controllersList.length, (_) {
          return {'weight': false, 'reps': false, 'rir': false};
        });
      }

      for (int s = 0; s < controllersList.length; s++) {
        final map = controllersList[s];
        final errorsForSet = _fieldErrors[i]![s];

        final weight = map['weight']?.text.trim() ?? '';
        final reps = map['reps']?.text.trim() ?? '';
        final rir = map['rir']?.text.trim() ?? '';

        final weightError = weight.isEmpty;
        final repsError = reps.isEmpty;
        final rirError = rir.isEmpty;

        errorsForSet['weight'] = weightError;
        errorsForSet['reps'] = repsError;
        errorsForSet['rir'] = rirError;

        if (weightError || repsError || rirError) {
          hasError = true;
        }
      }
    }

    if (hasError) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all sets before submitting.'),
        ),
      );
      return false;
    }

    setState(() {});
    return true;
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
              final exercises =
                  _sessionExercises ??
                  List<TrainingPlanExerciseEntity>.from(plan.exercises);

              final planKey = plan.id.toString();
              if (_planKey != planKey) {
                _planKey = planKey;
                _hasLoadedFromPrefs = false;
                _sessionExercises = null;
              }

              _initializeControllers(exercises);

              if (!_hasLoadedFromPrefs) {
                _hasLoadedFromPrefs = true;
                _loadSavedControllers(exercises);
              }

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
                        actions: [
                          IconButton(
                            icon: const Icon(
                              Icons.history,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Get.delete<PreviousWorkoutModalController>(
                                tag: plan.title,
                              );
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                useSafeArea: true,
                                showDragHandle: true,
                                backgroundColor: const Color(0XFF101021),
                                builder: (context) =>
                                    WorkoutHistoryModal(planTitle: plan.title),
                              );
                            },
                          ),
                          SizedBox(width: 8.w),
                        ],
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
                                : ListView(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 10.h,
                                    ),
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Exercises',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          OutlinedButton.icon(
                                            onPressed: _isChangingExercise
                                                ? null
                                                : () =>
                                                    _onChangeExercisePressed(
                                                      context,
                                                      exercises,
                                                    ),
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                color: Color(0xFF4CAF50),
                                              ),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 8.h,
                                              ),
                                              minimumSize: const Size(0, 0),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              visualDensity:
                                                  VisualDensity.compact,
                                            ),
                                            icon: _isChangingExercise
                                                ? SizedBox(
                                                    width: 14.w,
                                                    height: 14.w,
                                                    child:
                                                        const CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: Color(
                                                            0xFF4CAF50,
                                                          ),
                                                        ),
                                                  )
                                                : const Icon(
                                                    Icons.swap_horiz,
                                                    size: 16,
                                                  ),
                                            label: Text(
                                              _isChangingExercise
                                                  ? 'Loading...'
                                                  : 'Change Exercise',
                                              style: GoogleFonts.poppins(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12.h),
                                      ...List.generate(exercises.length, (index) {
                                        final exercise = exercises[index];
                                        return _ExerciseRow(
                                          exercise: exercise,
                                          index: index + 1,
                                          controllers:
                                              _exerciseControllers[index]!,
                                          errorFlags:
                                              _fieldErrors[index] ?? const [],
                                        );
                                      }),
                                      SizedBox(height: 8.h),
                                      _NotesInput(controller: _noteController),
                                      SizedBox(height: 24.h),
                                      _BottomButtons(
                                        onComplete: () {
                                          final isValid = _validateAllFields(
                                            exercises,
                                            context,
                                          );
                                          if (!isValid) {
                                            return;
                                          }
                                          final duration = context
                                              .read<WorkoutTimerCubit>()
                                              .state
                                              .duration;
                                          _onComplete(
                                            context,
                                            plan.title,
                                            exercises,
                                            duration,
                                          );
                                          _clearSavedControllers(exercises);
                                        },
                                      ),
                                      SizedBox(height: 20.h),
                                    ],
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
        final minutes =
            ((state.duration % 3600) ~/ 60).toString().padLeft(2, '0');
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
  final List<Map<String, bool>> errorFlags;

  const _ExerciseRow({
    required this.exercise,
    required this.index,
    required this.controllers,
    required this.errorFlags,
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
          color: isCompleted ? const Color(0xFF4CAF50) : const Color(0xFF2E2E5D),
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
                  widget.exercise.name,
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
                      onTap: () {
                        setState(() {
                          isCompleted = !isCompleted;
                        });
                      },
                      child: Icon(
                        isCompleted
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        color: isCompleted ? const Color(0xFF4CAF50) : Colors.white24,
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
                    final setLabel =
                        setModel != null ? setModel.sets.toString() : '${index + 1}';
                    final repsHint = setModel != null
                        ? setModel.repRange.toString()
                        : (widget.exercise.range ?? '');
                    final rirHint = setModel != null
                        ? setModel.rir.toString()
                        : (widget.exercise.rir ?? '');

                    final errorList = widget.errorFlags;
                    final errorMap =
                        errorList.length > index ? errorList[index] : const {};
                    final weightError = errorMap['weight'] ?? false;
                    final repsError = errorMap['reps'] ?? false;
                    final rirError = errorMap['rir'] ?? false;

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
                            isError: weightError,
                          ),
                          SizedBox(width: 8.w),
                          _inputBox(
                            setControllers['reps'],
                            hintText: repsHint,
                            isError: repsError,
                          ),
                          SizedBox(width: 8.w),
                          _inputBox(
                            setControllers['rir'],
                            hintText: rirHint,
                            isError: rirError,
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
