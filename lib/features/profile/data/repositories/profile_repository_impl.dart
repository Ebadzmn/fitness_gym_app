import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../domain/entities/profile_entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ApiException, ProfileEntity>> getProfile() async {
    try {
      final result = await remoteDataSource.fetchProfile();
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ApiException(message: e.message ?? 'Failed to fetch profile'),
      );
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }
}
