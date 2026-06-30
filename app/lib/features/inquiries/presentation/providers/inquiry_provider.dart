import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/inquiry_repository_impl.dart';
import '../../domain/entities/inquiry.dart';
import '../../domain/repositories/inquiry_repository.dart';

final inquiryRepositoryProvider = Provider<InquiryRepository>((ref) {
  return InquiryRepositoryImpl(apiClient: ref.watch(apiClientProvider));
});

final inquiryListProvider =
    StateNotifierProvider<InquiryListNotifier, AsyncValue<List<Inquiry>>>(
        (ref) {
  return InquiryListNotifier(ref.watch(inquiryRepositoryProvider));
});

class InquiryListNotifier extends StateNotifier<AsyncValue<List<Inquiry>>> {
  InquiryListNotifier(this._repository) : super(const AsyncValue.loading());

  final InquiryRepository _repository;

  Future<void> loadInquiries() async {
    state = const AsyncValue.loading();
    final result = await _repository.getInquiries();
    state = result.fold(
      (error) => AsyncValue.error(error, StackTrace.current),
      (inquiries) => AsyncValue.data(inquiries),
    );
  }
}

final submitInquiryProvider = FutureProvider.family<void, SubmitInquiryParams>(
  (ref, params) async {
    final repository = ref.watch(inquiryRepositoryProvider);
    final result = await repository.createInquiry(
      variantId: params.variantId,
      dealerId: params.dealerId,
      message: params.message,
    );
    result.fold(
      (error) => throw error,
      (_) => null,
    );
  },
);

class SubmitInquiryParams {
  final int variantId;
  final int? dealerId;
  final String? message;

  const SubmitInquiryParams({
    required this.variantId,
    this.dealerId,
    this.message,
  });
}
