import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/brand.dart';
import '../../domain/repositories/brand_repository.dart';

class BrandRepositoryImpl implements BrandRepository {
  BrandRepositoryImpl({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  @override
  Future<Either<AppException, List<Brand>>> getBrands() async {
    try {
      final response = await _api.get('/brands/');
      final data = response.data as List;
      final brands = data
          .map((json) => Brand.fromJson(json as Map<String, dynamic>))
          .toList();
      return Right(brands);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException('Failed to fetch brands'));
    }
  }
}
