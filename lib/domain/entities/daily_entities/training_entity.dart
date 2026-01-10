import 'package:equatable/equatable.dart';

class TrainingEntity extends Equatable {
  final bool trainingCompleted;
  final bool cardioCompleted;
  final String feedback;
  final Set<String> plans; // e.g., Placeholder, Push Fullbody, etc.
  final String cardioType; // e.g., Walking
  final String duration; // e.g., "30 min"
  final double intensity; // 1-10

  const TrainingEntity({
    required this.trainingCompleted,
    required this.cardioCompleted,
    required this.feedback,
    required this.plans,
    required this.cardioType,
    required this.duration,
    this.intensity = 1,
  });

  TrainingEntity copyWith({
    bool? trainingCompleted,
    bool? cardioCompleted,
    String? feedback,
    Set<String>? plans,
    String? cardioType,
    String? duration,
    double? intensity,
  }) => TrainingEntity(
    trainingCompleted: trainingCompleted ?? this.trainingCompleted,
    cardioCompleted: cardioCompleted ?? this.cardioCompleted,
    feedback: feedback ?? this.feedback,
    plans: plans ?? this.plans,
    cardioType: cardioType ?? this.cardioType,
    duration: duration ?? this.duration,
    intensity: intensity ?? this.intensity,
  );

  @override
  List<Object?> get props => [
    trainingCompleted,
    cardioCompleted,
    feedback,
    plans,
    cardioType,
    duration,
    intensity,
  ];

  Map<String, dynamic> toMap() => {
    'trainingCompleted': trainingCompleted,
    'cardioCompleted': cardioCompleted,
    'feedback': feedback,
    'plans': plans.toList(),
    'cardioType': cardioType,
    'duration': duration,
    'intensity': intensity,
  };
  factory TrainingEntity.fromMap(Map<String, dynamic> map) => TrainingEntity(
    trainingCompleted: map['trainingCompleted'] ?? true,
    cardioCompleted: map['cardioCompleted'] ?? true,
    feedback: map['feedback'] ?? '',
    plans: Set<String>.from(map['plans'] ?? const <String>[]),
    cardioType: map['cardioType'] ?? 'Walking',
    duration: map['duration'] ?? '30 min',
    intensity: (map['intensity'] ?? 1).toDouble(),
  );
}
