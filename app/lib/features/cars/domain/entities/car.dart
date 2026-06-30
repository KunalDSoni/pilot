import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/types/fuel_type.dart';
import '../../../../core/types/transmission_type.dart';
import '../../../brands/domain/entities/brand.dart';

part 'car.freezed.dart';
part 'car.g.dart';

@freezed
class Car with _$Car {
  const factory Car({
    required int id,
    required Brand brand,
    required String name,
    required int year,
    required String bodyType,
    required FuelType fuelType,
    required TransmissionType transmissionType,
    String? engine,
    double? mileage,
    int? seatingCapacity,
    double? minPrice,
    double? maxPrice,
    String? imageUrl,
    List<CarVariant>? variants,
  }) = _Car;

  factory Car.fromJson(Map<String, dynamic> json) => _$CarFromJson(json);
}

@freezed
class CarVariant with _$CarVariant {
  const factory CarVariant({
    required int id,
    required int carId,
    required String name,
    required double price,
    required FuelType fuelType,
    required TransmissionType transmissionType,
    double? mileage,
    List<CarColor>? availableColors,
  }) = _CarVariant;

  factory CarVariant.fromJson(Map<String, dynamic> json) =>
      _$CarVariantFromJson(json);
}

@freezed
class CarColor with _$CarColor {
  const factory CarColor({
    required int id,
    required String name,
    required String hexCode,
  }) = _CarColor;

  factory CarColor.fromJson(Map<String, dynamic> json) =>
      _$CarColorFromJson(json);
}
