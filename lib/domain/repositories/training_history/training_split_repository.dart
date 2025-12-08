import 'package:fitness_app/domain/entities/training_entities/training_split_entity.dart';

abstract class TrainingSplitRepository {
  Future<List<TrainingSplitItem>> getSplit();
}
