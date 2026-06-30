import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_exception.dart';
import '../entities/inquiry.dart';

abstract class InquiryRepository {
  Future<Either<AppException, Inquiry>> createInquiry({
    required int variantId,
    int? dealerId,
    String? message,
  });
  Future<Either<AppException, List<Inquiry>>> getInquiries({int page = 1});
}
