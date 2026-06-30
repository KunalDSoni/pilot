import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/inquiry.dart';
import '../../domain/repositories/inquiry_repository.dart';

class InquiryRepositoryImpl implements InquiryRepository {
  InquiryRepositoryImpl({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  @override
  Future<Either<AppException, Inquiry>> createInquiry({
    required int variantId,
    int? dealerId,
    String? message,
  }) async {
    try {
      final response = await _api.post('/inquiries/', data: {
        'variant_id': variantId,
        if (dealerId != null) 'dealer_id': dealerId,
        if (message != null) 'message': message,
      });
      final data = response.data as Map<String, dynamic>;
      return Right(Inquiry.fromJson(data));
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException('Failed to submit inquiry'));
    }
  }

  @override
  Future<Either<AppException, List<Inquiry>>> getInquiries(
      {int page = 1}) async {
    try {
      final response =
          await _api.get('/inquiries/', queryParameters: {'page': page});
      final data = response.data as Map<String, dynamic>;
      final inquiries = (data['items'] as List)
          .map((json) => Inquiry.fromJson(json as Map<String, dynamic>))
          .toList();
      return Right(inquiries);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException('Failed to fetch inquiries'));
    }
  }
}
