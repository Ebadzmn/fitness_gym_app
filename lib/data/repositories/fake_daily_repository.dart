import 'package:fitness_app/domain/entities/daily_entities/daily_tracking_entity.dart';
import 'package:fitness_app/domain/entities/daily_entities/nutrition_entity.dart';
import 'package:fitness_app/domain/entities/daily_entities/ped_health_entity.dart';
import 'package:fitness_app/domain/entities/daily_entities/training_entity.dart';
import 'package:fitness_app/domain/entities/daily_entities/well_being_entity.dart';
import 'package:fitness_app/domain/entities/daily_entities/vital_entity.dart';
import 'package:fitness_app/domain/entities/daily_entities/sleep_entity.dart';
import 'package:fitness_app/domain/entities/daily_entities/women_entity.dart';
import 'package:fitness_app/domain/repositories/daily/daily_repository.dart';

class FakeDailyRepository implements DailyRepository {
  @override
  Future<DailyTrackingEntity> loadInitial() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return DailyTrackingEntity(
      vital: const VitalEntity(
        dateLabel: '2023.08.15',
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
      sleep: const SleepEntity(
        durationText: '08 : 45 (Minutes)',
        quality: 8,
      ),
      training: const TrainingEntity(
        trainingCompleted: true,
        cardioCompleted: true,
        feedback: '',
        plans: <String>{},
        cardioType: 'Walking',
        duration: '30 min',
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
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}
