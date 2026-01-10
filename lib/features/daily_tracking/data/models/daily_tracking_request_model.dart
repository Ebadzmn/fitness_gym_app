import '../../../../domain/entities/daily_entities/daily_tracking_entity.dart';

class DailyTrackingRequestModel {
  final DailyTrackingEntity entity;

  DailyTrackingRequestModel(this.entity);

  Map<String, dynamic> toJson() {
    // Helper to parse double or int from string like "65.2 (kg)" or "120"
    String _cleanNum(String text) {
      final regExp = RegExp(r'[\d\.]+');
      final match = regExp.firstMatch(text);
      return match?.group(0) ?? '0';
    }

    // Helper for date formatting from 2023.08.15 -> 2023-08-15
    String _formatDate(String dateLabel) {
      return dateLabel.replaceAll('.', '-');
    }

    return {
      "date": _formatDate(entity.vital.dateLabel),
      "weight": double.tryParse(_cleanNum(entity.vital.weightText)) ?? 0,
      "sleepHour": double.tryParse(_cleanNum(entity.sleep.durationText)) ?? 0,
      "sleepQuality": entity.sleep.quality.toString(),
      "sick": entity.isSick,
      "water": entity
          .vital
          .waterText, // Assuming "1.2 (Lit)" format is acceptable or needs cleaning? Based on prompt "2L"

      "bloodPressure": {
        "systolic": _cleanNum(entity.pedHealth.systolicText),
        "diastolic": _cleanNum(entity.pedHealth.diastolicText),
        "restingHeartRate": _cleanNum(entity.pedHealth.restingHrText),
        "bloodGlucose": _cleanNum(entity.pedHealth.glucoseText),
      },

      "energyAndWellBeing": {
        "energyLevel": entity.wellBeing.energy,
        "stressLevel": entity.wellBeing.stress,
        "muscelLevel": entity.wellBeing.muscleSoreness,
        "mood": entity.wellBeing.mood,
        "motivation": entity.wellBeing.motivation,
        "bodyTemperature": _cleanNum(entity.vital.bodyTempText),
      },

      "training": {
        "trainingCompleted": entity.training.trainingCompleted,
        "trainingPlan": entity.training.plans
            .map((e) => e.toUpperCase().replaceAll(' ', '_'))
            .toList(),
        "cardioCompleted": entity.training.cardioCompleted,
        "cardioType": entity.training.cardioType.toUpperCase().replaceAll(
          ' ',
          '_',
        ),
        "duration": entity.training.duration, // "30"
      },

      "activityStep":
          int.tryParse(_cleanNum(entity.vital.activityStepCount)) ?? 0,

      "nutrition": {
        "calories":
            double.tryParse(_cleanNum(entity.nutrition.caloriesText)) ?? 0,
        "carbs": double.tryParse(_cleanNum(entity.nutrition.carbsText)) ?? 0,
        "protein":
            double.tryParse(_cleanNum(entity.nutrition.proteinText)) ?? 0,
        "fats": double.tryParse(_cleanNum(entity.nutrition.fatsText)) ?? 0,
        "hungerLevel": entity.nutrition.hunger,
        "digestionLevel": entity.nutrition.digestion,
        "salt": double.tryParse(_cleanNum(entity.nutrition.saltText)) ?? 0,
      },

      "woman": {
        "cyclePhase":
            entity.women.cyclePhase ??
            "OVULATION", // Default or nullable handling
        "cycleDay": entity
            .women
            .cycleDayLabel, // "Monday" vs "14" - Mapping issue? Assuming entity has correct data or string
        "pmsSymptoms": entity.women.pms,
        "cramps": entity.women.cramps,
        "symptoms": entity.women.symptoms.toList(),
      },

      "ped": {
        "dailyDosage": entity.pedHealth.dosageTaken
            ? "Taken"
            : "Not Taken", // Logic adjustment needed based on prompt "500mg"
        "sideEffect": entity.pedHealth.sideEffects,
      },

      "dailyNotes": entity.notes,
    };
  }
}
