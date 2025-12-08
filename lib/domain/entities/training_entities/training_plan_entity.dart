class TrainingPlanExerciseEntity {
  final String name;
  final String muscle;
  final String sets;
  final String type; // e.g., "Machine", "Cable"

  const TrainingPlanExerciseEntity({
    required this.name,
    required this.muscle,
    required this.sets,
    required this.type,
  });
}

class TrainingPlanEntity {
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final String type;
  final List<TrainingPlanExerciseEntity> exercises;

  const TrainingPlanEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.type,
    this.exercises = const [],
  });
}
