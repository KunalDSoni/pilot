import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_exception.dart';
import '../entities/car.dart';

class CarFilter {
  final int? brandId;
  final String? fuelType;
  final String? transmissionType;
  final String? bodyType;
  final double? minPrice;
  final double? maxPrice;
  final String? search;
  final int page;
  final int pageSize;

  const CarFilter({
    this.brandId,
    this.fuelType,
    this.transmissionType,
    this.bodyType,
    this.minPrice,
    this.maxPrice,
    this.search,
    this.page = 1,
    this.pageSize = 20,
  });

  CarFilter copyWith({
    int? brandId,
    String? fuelType,
    String? transmissionType,
    String? bodyType,
    double? minPrice,
    double? maxPrice,
    String? search,
    int? page,
    int? pageSize,
  }) {
    return CarFilter(
      brandId: brandId ?? this.brandId,
      fuelType: fuelType ?? this.fuelType,
      transmissionType: transmissionType ?? this.transmissionType,
      bodyType: bodyType ?? this.bodyType,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      search: search ?? this.search,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

class CarListResult {
  final List<Car> cars;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  const CarListResult({
    required this.cars,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });
}

abstract class CarRepository {
  Future<Either<AppException, CarListResult>> getCars(CarFilter filter);
  Future<Either<AppException, Car>> getCar(int id);
}
