import 'package:fitness_app/features/training/data/repositories/fake_exercise_repository.dart';
import 'package:fitness_app/domain/entities/training_entities/exercise_entity.dart';

class GetExercisesUseCase {
  final FakeExerciseRepository repo;
  GetExercisesUseCase(this.repo);
  Future<List<ExerciseEntity>> call() => repo.loadAll();
}
