import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';
import 'package:fitness_app/domain/repositories/training_history/training_plan_repository.dart';
import 'package:fitness_app/features/training/data/datasources/training_remote_datasource.dart';

class TrainingRepositoryImpl implements TrainingPlanRepository {
  final TrainingRemoteDataSource remoteDataSource;

  TrainingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TrainingPlanEntity>> getTrainingPlans() async {
    return await remoteDataSource.getTrainingPlans(
      '693ddd32418ae5411e5359d4',
    ); // Hardcoded user ID
  }

  @override
  Future<TrainingPlanEntity> getTrainingPlanById(String id) async {
    return await remoteDataSource.getTrainingPlanById(id);
  }
}
