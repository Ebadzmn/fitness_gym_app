import 'package:fitness_app/features/daily_tracking/data/datasources/daily_tracking_remote_datasource.dart';
import 'package:fitness_app/domain/entities/daily_entities/daily_tracking_entity.dart';
import 'package:fitness_app/domain/entities/daily_entities/nutrition_entity.dart';
import 'package:fitness_app/domain/entities/daily_entities/ped_health_entity.dart';
import 'package:fitness_app/domain/entities/daily_entities/training_entity.dart';
import 'package:fitness_app/domain/entities/daily_entities/well_being_entity.dart';
import 'package:fitness_app/domain/entities/daily_entities/vital_entity.dart';
import 'package:fitness_app/domain/entities/daily_entities/sleep_entity.dart';
import 'package:fitness_app/domain/entities/daily_entities/women_entity.dart';
import 'package:fitness_app/domain/repositories/daily/daily_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DailyRepositoryImpl implements DailyRepository {
  final DailyTrackingRemoteDataSource remoteDataSource;

  DailyRepositoryImpl({required this.remoteDataSource});

  String _formatDate(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  @override
  Future<DailyTrackingEntity> loadInitial() async {
    // Keeping local load for initial state logic for now, or could fetch from API if needed.
    // Assuming prompt only asked for POST on save, keeping GET logic as is (mock/local).
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final prefs = await SharedPreferences.getInstance();
    final trainingJson = prefs.getString('daily_training_last');
    TrainingEntity? persistedTraining;
    if (trainingJson != null) {
      try {
        persistedTraining = TrainingEntity.fromMap(jsonDecode(trainingJson));
      } catch (_) {}
    }

    // Auto-generate today's date
    final now = DateTime.now();
    final dateLabel =
        '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}';

    return DailyTrackingEntity(
      vital: VitalEntity(
        dateLabel: dateLabel,
        weightText: '',
        waterText: '',
        bodyTempText: '',
        activityStepCount: '',
      ),
      isSick: false,
      wellBeing: const WellBeingEntity(
        energy: 1,
        stress: 1,
        muscleSoreness: 1,
        mood: 1,
        motivation: 1,
      ),
      sleep: const SleepEntity(durationText: '', quality: 1),
      training:
          persistedTraining ??
          const TrainingEntity(
            trainingCompleted: true,
            cardioCompleted: true,
            feedback: '',
            plans: <String>{},
            cardioType: 'WALKING',
            duration: '',
            intensity: 1,
          ),
      nutrition: const NutritionEntity(
        dietLevel: 1,
        digestion: 1,
        hunger: 1,
        caloriesText: '',
        carbsText: '',
        proteinText: '',
        fatsText: '',
        saltText: '',
        challenge: '',
      ),
      women: const WomenEntity(
        cyclePhase: null,
        cycleDayLabel: 'Monday',
        pms: 1,
        cramps: 1,
        symptoms: <String>{},
      ),
      pedHealth: const PedHealthEntity(
        dosageTaken: false,
        sideEffects: '',
        systolicText: '',
        diastolicText: '',
        restingHrText: '',
        glucoseText: '',
      ),
      notes: '',
    );
  }

  @override
  Future<DailyTrackingEntity> loadByDate(DateTime date) {
    return remoteDataSource.fetchDailyTrackingByDate(_formatDate(date));
  }

  @override
  Future<void> save(DailyTrackingEntity entity) async {
    // Save to API
    await remoteDataSource.submitDailyTracking(entity);

    // Also keeping local persistence for training as per original code logic if desired,
    // but primary goal is API. I'll keep local save as backup/cache if needed or just do API.
    // The prompt specifically asked for API integration.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'daily_training_last',
      jsonEncode(entity.training.toMap()),
    );
  }
}
