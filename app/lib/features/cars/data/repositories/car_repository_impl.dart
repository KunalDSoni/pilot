import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/car.dart';
import '../../domain/repositories/car_repository.dart';

class CarRepositoryImpl implements CarRepository {
  CarRepositoryImpl({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  @override
  Future<Either<AppException, CarListResult>> getCars(CarFilter filter) async {
    try {
      final queryParams = <String, dynamic>{
        'page': filter.page,
        'page_size': filter.pageSize,
        if (filter.brandId != null) 'brand_id': filter.brandId,
        if (filter.fuelType != null) 'fuel_type': filter.fuelType,
        if (filter.transmissionType != null)
          'transmission_type': filter.transmissionType,
        if (filter.bodyType != null) 'body_type': filter.bodyType,
        if (filter.minPrice != null) 'min_price': filter.minPrice,
        if (filter.maxPrice != null) 'max_price': filter.maxPrice,
        if (filter.search != null) 'search': filter.search,
      };

      final response = await _api.get('/cars/', queryParameters: queryParams);
      final data = response.data as Map<String, dynamic>;

      final result = CarListResult(
        cars: (data['items'] as List)
            .map((json) => Car.fromJson(json as Map<String, dynamic>))
            .toList(),
        total: data['total'] as int,
        page: data['page'] as int,
        pageSize: data['page_size'] as int,
        totalPages: data['total_pages'] as int,
      );
      return Right(result);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException('Failed to fetch cars'));
    }
  }

  @override
  Future<Either<AppException, Car>> getCar(int id) async {
    try {
      final response = await _api.get('/cars/$id');
      final data = response.data as Map<String, dynamic>;
      return Right(Car.fromJson(data));
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException('Failed to fetch car details'));
    }
  }
}
