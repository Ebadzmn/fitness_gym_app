import 'package:fitness_app/domain/entities/training_entities/training_history_entity.dart';
import 'package:fitness_app/domain/repositories/training_history_repository.dart';

class FakeTrainingHistoryRepository implements TrainingHistoryRepository {
  @override
  Future<List<TrainingHistoryEntity>> getHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      const TrainingHistoryEntity(
        id: '1',
        month: 'November',
        workoutCount: 9,
        workoutName: 'Pull Fullbody',
        dateTime: 'Tuesday, 18 November 2025 at 16:52',
        notes: 'Warm up the rotator cuffs and hips',
        exercises: [
          HistoryExerciseEntity(
            name: 'Seated Row (Machine)',
            bestSetDisplay: 'Best: 68 kg x 8 @ 10 [F]',
            sets: [
              HistorySetEntity(weightAndReps: '36 kg x 6', oneRm: '42'),
              HistorySetEntity(weightAndReps: '50 kg x 6', oneRm: '51'),
            ],
          ),
          HistoryExerciseEntity(
            name: 'Wide Row (Machine)',
            bestSetDisplay: 'Best: 65 kg x 7 @ 10 [F]',
            sets: [
              HistorySetEntity(weightAndReps: '20 kg x 6', oneRm: '23'),
              HistorySetEntity(weightAndReps: '40 kg x 2', oneRm: '41'),
            ],
          ),
          HistoryExerciseEntity(
            name: 'Wide Row Machine',
            bestSetDisplay: 'Best: 65 kg x 7 @ 10 [F]',
            sets:
                [], // Truncated for brevity in list view, details not shown in screenshot for 3rd item
          ),
        ],
        duration: '1 h 31 m',
        volume: '5000(kg)',
        prs: '0 PRs',
      ),
    ];
  }
}
