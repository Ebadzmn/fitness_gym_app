import 'dart:async';
import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';
import 'package:fitness_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:fitness_app/features/training/data/models/training_history_request_model.dart';
import 'package:fitness_app/features/training/domain/repositories/exercise_repository.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_plan_by_id_usecase.dart';
import 'package:fitness_app/features/training/domain/usecases/save_training_history_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutSessionController extends GetxController {
  final GetTrainingPlanByIdUseCase getTrainingPlanById;
  final SaveTrainingHistoryUseCase _saveTrainingHistory;
  final GetProfileUseCase getProfile;
  final ExerciseRepository exerciseRepository;
  final SharedPreferences sharedPreferences;

  WorkoutSessionController({
    required this.getTrainingPlanById,
    required SaveTrainingHistoryUseCase saveTrainingHistory,
    required this.getProfile,
    required this.exerciseRepository,
    required this.sharedPreferences,
  }) : _saveTrainingHistory = saveTrainingHistory;

  // UI State
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<TrainingPlanEntity> plan = Rxn<TrainingPlanEntity>();
  final RxList<TrainingPlanExerciseEntity> sessionExercises =
      <TrainingPlanExerciseEntity>[].obs;
  final RxBool isChangingExercise = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isSaved = false.obs;

  // Form State
  final Map<int, List<Map<String, TextEditingController>>> exerciseControllers =
      {};
  final Map<int, List<Map<String, RxBool>>> fieldErrors = {};
  final TextEditingController noteController = TextEditingController();

  // Timer State
  final RxInt duration = 0.obs;
  final RxBool isTimerRunning = false.obs;
  // Timer is now managed by Background Service & TimerBloc

  String? _planKey;
  bool _hasLoadedFromPrefs = false;

  @override
  void onInit() {
    super.onInit();
    noteController.addListener(_onNoteChanged);
  }

  @override
  void onClose() {
    noteController.removeListener(_onNoteChanged);
    noteController.dispose();
    _disposeControllers();
    super.onClose();
  }

  void _disposeControllers() {
    for (final list in exerciseControllers.values) {
      for (final controllers in list) {
        for (final c in controllers.values) {
          c.dispose();
        }
      }
    }
    exerciseControllers.clear();
    fieldErrors.clear();
  }

  Future<void> loadWorkoutSession(String planId) async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await getTrainingPlanById(planId);
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
      },
      (loadedPlan) {
        plan.value = loadedPlan;
        _planKey = loadedPlan.id.toString();

        if (sessionExercises.isEmpty) {
          sessionExercises.assignAll(loadedPlan.exercises);
        }

        _initializeControllers(sessionExercises);

        if (!_hasLoadedFromPrefs) {
          _hasLoadedFromPrefs = true;
          _loadSavedControllers(sessionExercises);
        }

        isLoading.value = false;
      },
    );
  }

  void _initializeControllers(List<TrainingPlanExerciseEntity> exercises) {
    for (int i = 0; i < exercises.length; i++) {
      final exercise = exercises[i];
      final setsDetail = (exercise.exerciseSets as List?) ?? const [];
      final setsCount = setsDetail.isNotEmpty ? setsDetail.length : 1;

      final existing = exerciseControllers[i];
      if (existing != null && existing.length == setsCount) {
        continue;
      }

      final oldList = exerciseControllers[i];
      if (oldList != null) {
        for (final map in oldList) {
          for (final c in map.values) {
            c.dispose();
          }
        }
      }

      exerciseControllers[i] = List.generate(setsCount, (setIndex) {
        final controllers = {
          'weight': TextEditingController(),
          'reps': TextEditingController(),
          'rir': TextEditingController(),
        };
        _attachControllerListeners(i, setIndex, controllers);
        return controllers;
      });

      fieldErrors[i] = List.generate(setsCount, (_) {
        return {
          'weight': false.obs,
          'reps': false.obs,
          'rir': false.obs,
        };
      });
    }
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

  // Persistent State Logic
  String _buildFieldKey(int exerciseIndex, int setIndex, String field) {
    return 'workout_${_planKey}_ex${exerciseIndex}_set${setIndex}_$field';
  }

  String _buildNoteKey() {
    return 'workout_${_planKey}_note';
  }

  Future<void> _saveField(
    int exerciseIndex,
    int setIndex,
    String field,
    String value,
  ) async {
    if (_planKey == null) return;
    final key = _buildFieldKey(exerciseIndex, setIndex, field);
    await sharedPreferences.setString(key, value);
  }

  Future<void> _saveNote(String value) async {
    if (_planKey == null) return;
    final key = _buildNoteKey();
    await sharedPreferences.setString(key, value);
  }

  void _onNoteChanged() {
    _saveNote(noteController.text);
  }

  Future<void> _loadSavedControllers(
    List<TrainingPlanExerciseEntity> exercises,
  ) async {
    if (_planKey == null) return;

    for (int i = 0; i < exercises.length; i++) {
      final controllersList = exerciseControllers[i];
      if (controllersList == null) continue;

      for (int setIndex = 0; setIndex < controllersList.length; setIndex++) {
        final map = controllersList[setIndex];

        for (final field in ['weight', 'reps', 'rir']) {
          final key = _buildFieldKey(i, setIndex, field);
          final value = sharedPreferences.getString(key);
          if (value != null && value.isNotEmpty) {
            final controller = map[field];
            if (controller != null && controller.text != value) {
              controller.text = value;
            }
          }
        }
      }
    }

    final noteKey = _buildNoteKey();
    final noteValue = sharedPreferences.getString(noteKey);
    if (noteValue != null && noteValue.isNotEmpty) {
      if (noteController.text != noteValue) {
        noteController.text = noteValue;
      }
    }
  }

  Future<void> _clearSavedControllers() async {
    if (_planKey == null) return;

    for (int i = 0; i < sessionExercises.length; i++) {
      final controllersList = exerciseControllers[i];
      if (controllersList == null) continue;

      for (int setIndex = 0; setIndex < controllersList.length; setIndex++) {
        for (final field in ['weight', 'reps', 'rir']) {
          final key = _buildFieldKey(i, setIndex, field);
          await sharedPreferences.remove(key);
        }
      }
    }

    final noteKey = _buildNoteKey();
    await sharedPreferences.remove(noteKey);
  }

  // Timer logic moved to TimerBloc & Background Service

  // Exercise Picker Logic
  Future<void> changeExercise(
    List<TrainingPlanExerciseEntity> currentExercises,
    BuildContext context,
    Function(List<dynamic>) showPicker,
  ) async {
    if (isChangingExercise.value) return;

    isChangingExercise.value = true;

    final result = await exerciseRepository.getExercises();

    isChangingExercise.value = false;

    await result.fold(
      (failure) async {
        Get.snackbar('Error', failure.message);
      },
      (items) async {
        final selected = await showPicker(items);
        if (selected == null) return;

        final newExercise = TrainingPlanExerciseEntity(
          name: selected.title,
          sets: '1',
          muscle: selected.category,
          type: selected.equipment,
          range: '',
          rir: '',
          exerciseSets: const [],
        );

        final next = List<TrainingPlanExerciseEntity>.from(currentExercises)
          ..add(newExercise);
        sessionExercises.assignAll(next);
        _initializeControllers(next);

        Get.snackbar('Success', '${selected.title} added to workout.');
      },
    );
  }

  // Submission Logic
  bool validateAllFields() {
    bool hasError = false;

    for (int i = 0; i < sessionExercises.length; i++) {
      final controllersList = exerciseControllers[i];
      if (controllersList == null || controllersList.isEmpty) {
        hasError = true;
        continue;
      }

      for (int s = 0; s < controllersList.length; s++) {
        final map = controllersList[s];
        final errorsForSet = fieldErrors[i]![s];

        final weight = map['weight']?.text.trim() ?? '';
        final reps = map['reps']?.text.trim() ?? '';
        final rir = map['rir']?.text.trim() ?? '';

        final weightError = weight.isEmpty;
        final repsError = reps.isEmpty;
        final rirError = rir.isEmpty;

        errorsForSet['weight']?.value = weightError;
        errorsForSet['reps']?.value = repsError;
        errorsForSet['rir']?.value = rirError;

        if (weightError || repsError || rirError) {
          hasError = true;
        }
      }
    }

    if (hasError) {
      Get.snackbar('Incomplete', 'Please complete all sets before submitting.');
      return false;
    }

    return true;
  }

  Future<void> onComplete() async {
    if (!validateAllFields()) return;

    isSaving.value = true;

    final List<PushData> pushData = [];

    for (int i = 0; i < sessionExercises.length; i++) {
      final exercise = sessionExercises[i];
      final setsDetail = (exercise.exerciseSets as List?) ?? const [];
      final controllersList = exerciseControllers[i];

      if (controllersList == null || controllersList.isEmpty) continue;

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
        for (int s = 0; s < setsDetail.length; s++) {
          final controllers = controllersList.length > s
              ? controllersList[s]
              : controllersList.last;
          final setModel = setsDetail[s];
          final weight = num.tryParse(controllers['weight']?.text ?? '0') ?? 0;
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

    final currentDuration = duration.value;
    final hours = (currentDuration ~/ 3600).toString();
    final minutes = ((currentDuration % 3600) ~/ 60).toString();

    // Get UserID
    final profileResult = await getProfile();
    String? userId;
    profileResult.fold(
      (failure) {
        errorMessage.value = 'Failed to get user profile: ${failure.message}';
        isSaving.value = false;
      },
      (profile) {
        userId = profile.athlete.id;
      },
    );

    if (userId == null) return;

    final request = TrainingHistoryRequest(
      userId: userId!,
      trainingName: plan.value?.title ?? '',
      time: TrainingTime(hour: hours, minite: minutes),
      pushData: pushData,
      note: noteController.text,
      dateTime: DateTime.now(), // Captured at the moment of submission
    );

    final result = await _saveTrainingHistory(request);
    result.fold(
      (failure) {
        Get.snackbar('Error', failure.message);
        isSaving.value = false;
      },
      (_) async {
        await _clearSavedControllers();
        isSaved.value = true;
        isSaving.value = false;
        Get.back();
        Get.snackbar('Success', 'Workout saved successfully!');
      },
    );
  }
}
