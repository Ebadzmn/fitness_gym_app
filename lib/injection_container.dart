import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/apiUrls/api_urls.dart';
import 'core/network/api_client.dart';
import 'core/storage/token_storage.dart';
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

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      tokenStorage: sl(),
    ),
  );

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
  sl.registerFactory(
    () => DailyBloc(
      getInitial: sl(),
      saveDaily: sl(),
    ),
  );

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

  //! Core
  sl.registerLazySingleton<TokenStorage>(
    () => TokenStorage(sl()),
  );
  sl.registerLazySingleton<NetworkConfig>(
    () => NetworkConfig(baseUrl: ApiUrls.baseUrl),
  );
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(config: sl(), tokenStorage: sl()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
}
