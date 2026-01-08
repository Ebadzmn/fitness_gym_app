import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/apiUrls/api_urls.dart';
import 'core/network/api_client.dart';
import 'core/storage/token_storage.dart';
import 'core/session/session_manager.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/daily_tracking/data/datasources/daily_tracking_remote_datasource.dart';
import 'features/daily_tracking/data/repositories/daily_repository_impl.dart';
import 'domain/repositories/daily/daily_repository.dart';
import 'domain/usecases/daily/get_daily_initial_usecase.dart';
import 'domain/usecases/daily/save_daily_usecase.dart';
import 'presentation/daily/daily_tracking/presentation/pages/bloc/daily_bloc.dart';
import 'features/training/data/datasources/training_remote_datasource.dart';
import 'features/training/data/repositories/training_repository_impl.dart';
import 'domain/repositories/training_history/training_plan_repository.dart';
import 'features/training/domain/usecases/get_training_plans_usecase.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_plan_by_id_usecase.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/workout_session/workout_session_cubit.dart';
import 'features/training/presentation/pages/bloc/exercise_bloc/exercise_bloc.dart';
import 'features/training/domain/usecases/get_exercises_usecase.dart';
import 'features/training/domain/repositories/exercise_repository.dart';
import 'features/training/data/repositories/exercise_repository_impl.dart';
import 'features/training/data/datasources/exercise_remote_data_source.dart';
import 'features/training/data/datasources/training_split_remote_data_source.dart';
import 'features/training/data/repositories/training_split_repository_impl.dart';
import 'domain/repositories/training_history/training_split_repository.dart';
import 'features/training/domain/usecases/get_training_split_usecase.dart';
import 'features/training/presentation/pages/bloc/training_spilt2/training_split_bloc.dart';
import 'features/nutrition/data/datasources/nutrition_remote_data_source.dart';
import 'features/nutrition/data/repositories/nutrition_repository_impl.dart';
import 'features/nutrition/data/repositories/nutrition_repository.dart';
import 'features/nutrition/domain/usecases/get_nutrition_plan_usecase.dart';
import 'features/nutrition/presentation/pages/bloc/nutrition_plan/nutrition_plan_bloc.dart';
import 'features/nutrition/presentation/pages/bloc/track_meals/track_meals_bloc.dart';
import 'features/nutrition/domain/usecases/get_track_meals_usecase.dart';
import 'features/nutrition/domain/usecases/save_track_meal_usecase.dart';
import 'features/nutrition/domain/usecases/delete_tracked_food_item_usecase.dart';
import 'features/nutrition/domain/usecases/add_food_item_to_meal_usecase.dart';
import 'features/nutrition/domain/usecases/get_nutrition_statistics_usecase.dart';
import 'features/nutrition/presentation/pages/bloc/nutrition_statistics/nutrition_statistics_bloc.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_supplements_usecase.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/nutrition_supplement/nutrition_supplement_bloc.dart';
import 'features/profile/data/datasources/profile_remote_data_source.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_profile_usecase.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());

  //! Core
  sl.registerLazySingleton<TokenStorage>(() => TokenStorage(sl()));
  sl.registerLazySingleton<SessionManager>(
    () => SessionManager(tokenStorage: sl()),
  );
  sl.registerLazySingleton<NetworkConfig>(
    () => NetworkConfig(baseUrl: ApiUrls.baseUrl),
  );
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(config: sl(), tokenStorage: sl(), sessionManager: sl()),
  );

  //! Features - Auth
  // Bloc
  sl.registerFactory(() => AuthBloc(loginUseCase: sl(), tokenStorage: sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );

  //! Features - Daily Tracking
  // Bloc
  sl.registerFactory(() => DailyBloc(getInitial: sl(), saveDaily: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetDailyInitialUseCase(sl()));
  sl.registerLazySingleton(() => SaveDailyUseCase(sl()));

  // Repository
  sl.registerLazySingleton<DailyRepository>(
    () => DailyRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<DailyTrackingRemoteDataSource>(
    () => DailyTrackingRemoteDataSourceImpl(apiClient: sl()),
  );

  //! Features - Training
  // Bloc
  // TrainingPlanBloc is created in the UI using provided UseCase, or can be registered here if needed factory.
  // For now, staying consistent with existing pattern if Blocs are factories.
  sl.registerFactory(() => WorkoutSessionCubit(getTrainingPlanById: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetTrainingPlansUseCase(sl()));
  sl.registerLazySingleton(() => GetTrainingPlanByIdUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<TrainingPlanRepository>(
    () => TrainingRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<TrainingRemoteDataSource>(
    () => TrainingRemoteDataSourceImpl(apiClient: sl()),
  );

  // Exercise Feature
  sl.registerFactory(() => ExerciseBloc(getExercises: sl()));
  sl.registerLazySingleton(() => GetExercisesUseCase(sl()));
  sl.registerLazySingleton<ExerciseRepository>(
    () => ExerciseRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ExerciseRemoteDataSource>(
    () => ExerciseRemoteDataSourceImpl(apiClient: sl()),
  );

  // Training Split Feature
  sl.registerFactory(() => TrainingSplitBloc(getSplit: sl()));
  sl.registerLazySingleton(() => GetTrainingSplitUseCase(sl()));
  sl.registerLazySingleton<TrainingSplitRepository>(
    () => TrainingSplitRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<TrainingSplitRemoteDataSource>(
    () => TrainingSplitRemoteDataSourceImpl(apiClient: sl()),
  );

  // Nutrition Feature
  sl.registerFactory(() => NutritionPlanBloc(getPlan: sl()));
  sl.registerLazySingleton(
    () => GetNutritionPlanUseCase(sl()),
  ); // Changed from GetNutritionInitialUseCase to match original
  sl.registerLazySingleton(() => GetSupplementsUseCase(sl()));
  sl.registerLazySingleton<NutritionRepository>(
    () => NutritionRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<NutritionRemoteDataSource>(
    () => NutritionRemoteDataSourceImpl(apiClient: sl()),
  );

  // Track Meals Feature
  sl.registerFactory(
    () => TrackMealsBloc(
      initialDate: DateTime.now(),
      getMeals: sl(), // Kept original 'getMeals'
      getPlan: sl(),
      saveMeal: sl(),
      deleteFoodItem: sl(),
    ),
  );
  sl.registerFactory(() => NutritionSupplementBloc(getSupplements: sl()));
  sl.registerLazySingleton(() => GetTrackMealsUseCase(sl()));
  sl.registerLazySingleton(() => SaveTrackMealUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTrackedFoodItemUseCase(sl()));
  // AddFoodToMeal
  sl.registerLazySingleton(() => AddFoodItemToMealUseCase(sl()));

  // Nutrition Statistics
  sl.registerFactory(() => NutritionStatisticsBloc(getStatistics: sl()));
  sl.registerLazySingleton(() => GetNutritionStatisticsUseCase(sl()));

  // Feature - Profile
  sl.registerFactory(() => ProfileBloc(getProfile: sl()));
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(apiClient: sl()),
  );
}
