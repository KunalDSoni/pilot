import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/car_repository_impl.dart';
import '../../domain/entities/car.dart';
import '../../domain/repositories/car_repository.dart';

final carRepositoryProvider = Provider<CarRepository>((ref) {
  return CarRepositoryImpl(apiClient: ref.watch(apiClientProvider));
});

final carListProvider =
    StateNotifierProvider<CarListNotifier, AsyncValue<List<Car>>>((ref) {
  return CarListNotifier(ref.watch(carRepositoryProvider));
});

class CarListNotifier extends StateNotifier<AsyncValue<List<Car>>> {
  CarListNotifier(this._repository) : super(const AsyncValue.loading()) {
    _filter = const CarFilter();
  }

  final CarRepository _repository;
  CarFilter _filter = const CarFilter();
  bool _hasMore = true;

  CarFilter get filter => _filter;

  Future<void> loadCars({bool refresh = false}) async {
    if (refresh) {
      _filter = _filter.copyWith(page: 1);
      _hasMore = true;
    }

    state = const AsyncValue.loading();
    final result = await _repository.getCars(_filter);
    state = result.fold(
      (error) => AsyncValue.error(error, StackTrace.current),
      (data) {
        _hasMore = data.page < data.totalPages;
        return AsyncValue.data(data.cars);
      },
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    _filter = _filter.copyWith(page: _filter.page + 1);
    final result = await _repository.getCars(_filter);
    result.fold(
      (error) => null,
      (data) {
        _hasMore = data.page < data.totalPages;
        state = AsyncValue.data([...state.value ?? [], ...data.cars]);
      },
    );
  }

  void updateFilter(CarFilter filter) {
    _filter = filter;
    loadCars(refresh: true);
  }

  void setSearch(String query) {
    _filter = _filter.copyWith(search: query.isEmpty ? null : query, page: 1);
    loadCars(refresh: true);
  }

  void setBrandFilter(int? brandId) {
    _filter = _filter.copyWith(brandId: brandId, page: 1);
    loadCars(refresh: true);
  }

  void setFuelType(String? fuelType) {
    _filter = _filter.copyWith(fuelType: fuelType, page: 1);
    loadCars(refresh: true);
  }
}

final carDetailProvider =
    FutureProvider.family<Car, int>((ref, carId) async {
  final repository = ref.watch(carRepositoryProvider);
  final result = await repository.getCar(carId);
  return result.fold(
    (error) => throw error,
    (car) => car,
  );
});
