import 'package:equatable/equatable.dart';

class TrainingEntity extends Equatable {
  final bool trainingCompleted;
  final bool cardioCompleted;
  final String feedback;
  final Set<String> plans; // e.g., Placeholder, Push Fullbody, etc.
  final String cardioType; // e.g., Walking
  final String duration; // e.g., "30 min"

  const TrainingEntity({
    required this.trainingCompleted,
    required this.cardioCompleted,
    required this.feedback,
    required this.plans,
    required this.cardioType,
    required this.duration,
  });

  TrainingEntity copyWith({
    bool? trainingCompleted,
    bool? cardioCompleted,
    String? feedback,
    Set<String>? plans,
    String? cardioType,
    String? duration,
  }) => TrainingEntity(
        trainingCompleted: trainingCompleted ?? this.trainingCompleted,
        cardioCompleted: cardioCompleted ?? this.cardioCompleted,
        feedback: feedback ?? this.feedback,
        plans: plans ?? this.plans,
        cardioType: cardioType ?? this.cardioType,
        duration: duration ?? this.duration,
      );

  @override
  List<Object?> get props => [trainingCompleted, cardioCompleted, feedback, plans, cardioType, duration];
}

