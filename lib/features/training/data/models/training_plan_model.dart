import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';

class TrainingPlanModel extends TrainingPlanEntity {
  const TrainingPlanModel({
    required super.id,
    required super.title,
    required super.subtitle, // Generated from exercises
    required super.date,
    super.difficulty,
    super.type,
    super.exercises,
  });

  factory TrainingPlanModel.fromJson(Map<String, dynamic> json) {
    // Parse exercises first to generate subtitle
    final List<TrainingPlanExerciseEntity> exercises =
        (json['exercise'] as List<dynamic>?)
            ?.map((e) => TrainingPlanExerciseModel.fromJson(e))
            .toList() ??
        [];

    // Generate subtitle: join first few exercise names
    final subtitle = exercises.isNotEmpty
        ? exercises.map((e) => e.name).take(2).join(', ')
        : 'No Exercises';

    return TrainingPlanModel(
      id: json['_id']?.toString() ?? '',
      title:
          (json['traingPlanName'] ?? json['title'])?.toString() ??
          'Untitled Plan',
      subtitle: subtitle,
      date: json['createdAt']?.toString() ?? '',
      difficulty:
          json['dificulty']?.toString() ?? json['difficulty']?.toString(),
      type: json['type']?.toString(),
      exercises: exercises,
    );
  }
}

class TrainingPlanExerciseModel extends TrainingPlanExerciseEntity {
  const TrainingPlanExerciseModel({
    required super.name,
    super.muscle,
    required super.sets,
    super.rep,
    super.range,
    super.comment,
    super.type,
    super.rir,
  });

  factory TrainingPlanExerciseModel.fromJson(Map<String, dynamic> json) {
    // Handle exerciseSets array if present
    String? sets;
    String? range;
    String? rir;
    
    if (json['exerciseSets'] != null && json['exerciseSets'] is List) {
      final exerciseSets = json['exerciseSets'] as List<dynamic>;
      if (exerciseSets.isNotEmpty) {
        final firstSet = exerciseSets[0] as Map<String, dynamic>;
        sets = firstSet['sets']?.toString();
        range = firstSet['repRange']?.toString();
        rir = firstSet['rir']?.toString();
      }
    }
    
    return TrainingPlanExerciseModel(
      name:
          (json['exerciseName'] ?? json['name'])?.toString() ??
          'Unknown Exercise',
      sets: sets ?? json['sets']?.toString() ?? '0',
      rep: (json['rep'] ?? json['reps'])?.toString(),
      range: range ?? (json['repRange'] ?? json['range'])?.toString(),
      comment: (json['excerciseNote'] ?? json['comment'])?.toString(),
      muscle: json['muscle']?.toString(),
      type: json['type']?.toString(),
      rir: rir ?? json['rir']?.toString(),
    );
  }
}
