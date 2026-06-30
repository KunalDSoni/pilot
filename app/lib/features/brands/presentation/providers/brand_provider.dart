import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/brand_repository_impl.dart';
import '../../domain/entities/brand.dart';
import '../../domain/repositories/brand_repository.dart';

final brandRepositoryProvider = Provider<BrandRepository>((ref) {
  return BrandRepositoryImpl(apiClient: ref.watch(apiClientProvider));
});

final brandListProvider = FutureProvider<List<Brand>>((ref) async {
  final repository = ref.watch(brandRepositoryProvider);
  final result = await repository.getBrands();
  return result.fold(
    (error) => throw error,
    (brands) => brands,
  );
});
