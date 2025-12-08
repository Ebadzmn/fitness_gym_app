class TrainingHistoryEntity {
  final String id;
  final String month;
  final int workoutCount;
  final String workoutName;
  final String dateTime;
  final String notes; // Added notes
  final List<HistoryExerciseEntity> exercises; // Changed from List<String>
  final String duration;
  final String volume;
  final String prs;

  const TrainingHistoryEntity({
    required this.id,
    required this.month,
    required this.workoutCount,
    required this.workoutName,
    required this.dateTime,
    this.notes = '',
    required this.exercises,
    required this.duration,
    required this.volume,
    required this.prs,
  });
}

class HistoryExerciseEntity {
  final String name;
  final List<HistorySetEntity> sets;
  final String
  bestSetDisplay; // For the history list card (e.g. "Best: 68 kg x 8 @ 10 [F]")

  const HistoryExerciseEntity({
    required this.name,
    required this.sets,
    required this.bestSetDisplay,
  });
}

class HistorySetEntity {
  final String weightAndReps; // e.g. "36 kg x 6"
  final String oneRm; // e.g. "42"

  const HistorySetEntity({required this.weightAndReps, required this.oneRm});
}
