import 'package:flutter_test/flutter_test.dart';
import 'package:car_ai/features/cars/domain/repositories/car_repository.dart';

void main() {
  group('CarFilter', () {
    test('has default values', () {
      const filter = CarFilter();
      expect(filter.page, 1);
      expect(filter.pageSize, 20);
      expect(filter.brandId, isNull);
      expect(filter.search, isNull);
    });

    test('copyWith updates values', () {
      const filter = CarFilter();
      final updated = filter.copyWith(page: 2, search: 'Swift');
      expect(updated.page, 2);
      expect(updated.search, 'Swift');
      expect(updated.brandId, isNull);
    });

    test('copyWith resets page when brand filter changes', () {
      const filter = CarFilter(page: 3);
      final updated = filter.copyWith(brandId: 1, page: 1);
      expect(updated.page, 1);
      expect(updated.brandId, 1);
    });
  });

  group('CarListResult', () {
    test('creates with correct values', () {
      final result = CarListResult(
        cars: [],
        total: 0,
        page: 1,
        pageSize: 20,
        totalPages: 0,
      );
      expect(result.cars, isEmpty);
      expect(result.total, 0);
    });
  });
}
