import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';
import 'package:fitness_app/domain/repositories/training_plan_repository.dart';

class FakeTrainingPlanRepository implements TrainingPlanRepository {
  @override
  Future<List<TrainingPlanEntity>> getTrainingPlans() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return const [
      TrainingPlanEntity(
        id: '1',
        title: 'PLACEHOLDER',
        subtitle: 'No Exercises',
        date: '10-10-2025',
        type: 'Placeholder',
        exercises: [],
      ),
      TrainingPlanEntity(
        id: '2',
        title: 'TRAINING PLAN',
        subtitle: 'Leterral Rise\n(Mechine)',
        date: '10-10-2025',
        type: 'Training Plan',
        exercises: [
          TrainingPlanExerciseEntity(
            name: 'Lateral Raise (Machine)',
            muscle: 'Shoulders',
            sets: '2 X',
            type: 'Machine',
          ),
          TrainingPlanExerciseEntity(
            name: 'Bicep Curl (Cable)',
            muscle: 'Arms',
            sets: '3 x',
            type: 'Cable',
          ),
          TrainingPlanExerciseEntity(
            name: 'Triceps Extension ( Mechine)',
            muscle: 'Arms',
            sets: '2 x',
            type: 'Machine',
          ),
          TrainingPlanExerciseEntity(
            name: 'Y-Raisel',
            muscle: 'Shoulders',
            sets: '2 x',
            type: 'Free Weight',
          ),
          TrainingPlanExerciseEntity(
            name: 'Smith Machine Shoulders Press',
            muscle: 'Shoulders',
            sets: '2 x',
            type: 'Machine',
          ),
        ],
      ),
      TrainingPlanEntity(
        id: '3',
        title: 'PUSH FULLBODY',
        subtitle: 'Lateral Rise\n(Dumbble)',
        date: '10-10-2025',
        type: 'Push Fullbody',
        exercises: [
          TrainingPlanExerciseEntity(
            name: 'Lateral Raise (Dumbble)',
            muscle: 'Shoulders',
            sets: '3 X',
            type: 'Dumbbell',
          ),
          TrainingPlanExerciseEntity(
            name: 'Chest Press',
            muscle: 'Chest',
            sets: '3 x',
            type: 'Machine',
          ),
        ],
      ),
      TrainingPlanEntity(
        id: '4',
        title: 'TRAININGS PLAN',
        subtitle: 'Lateral Rise\n(Mechine)',
        date: '10-10-2025',
        type: 'Trainings Plan',
        exercises: [
          TrainingPlanExerciseEntity(
            name: 'Lateral Raise (Machine)',
            muscle: 'Shoulders',
            sets: '2 X',
            type: 'Machine',
          ),
          TrainingPlanExerciseEntity(
            name: 'Bicep Curl (Cable)',
            muscle: 'Arms',
            sets: '3 x',
            type: 'Cable',
          ),
        ],
      ),
    ];
  }
}
