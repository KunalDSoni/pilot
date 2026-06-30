import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_exception.dart';
import '../entities/brand.dart';

abstract class BrandRepository {
  Future<Either<AppException, List<Brand>>> getBrands();
}
