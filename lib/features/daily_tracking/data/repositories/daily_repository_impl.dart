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
    final dateLabel = '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}';
    
    return DailyTrackingEntity(
      vital: VitalEntity(
        dateLabel: dateLabel,
        weightText: '65.2 (kg)',
        waterText: '1.2 (Lit)',
        bodyTempText: '',
        activityTimeText: '08:00',
      ),
      isSick: false,
      wellBeing: const WellBeingEntity(
        energy: 6,
        stress: 6,
        muscleSoreness: 6,
        mood: 6,
        motivation: 6,
      ),
      sleep: const SleepEntity(durationText: '08 : 45 (Minutes)', quality: 8),
      training: persistedTraining ??
          const TrainingEntity(
            trainingCompleted: true,
            cardioCompleted: true,
            feedback: '',
            plans: <String>{},
            cardioType: 'Walking',
            duration: '30',
            intensity: 6,
          ),
      nutrition: const NutritionEntity(
        dietLevel: 6,
        digestion: 6,
        hunger: 6,
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
        pms: 6,
        cramps: 6,
        symptoms: <String>{},
      ),
      pedHealth: const PedHealthEntity(
        dosageTaken: false,
        sideEffects: '',
        systolicText: '120 (mmhg)',
        diastolicText: '80 (mmhg)',
        restingHrText: '40-60 (BPM)',
        glucoseText: '',
      ),
      notes: '',
    );
  }

  @override
  Future<void> save(DailyTrackingEntity entity) async {
    // Save to API
    await remoteDataSource.submitDailyTracking(entity);
    
    // Also keeping local persistence for training as per original code logic if desired,
    // but primary goal is API. I'll keep local save as backup/cache if needed or just do API.
    // The prompt specifically asked for API integration.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('daily_training_last', jsonEncode(entity.training.toMap()));
  }
}
