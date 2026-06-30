import 'package:flutter_test/flutter_test.dart';
import 'package:car_ai/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:car_ai/features/auth/presentation/providers/auth_provider.dart';

void main() {
  group('AuthState', () {
    test('initial state has correct defaults', () {
      const state = AuthState();
      expect(state.status, AuthStatus.initial);
      expect(state.user, isNull);
      expect(state.errorMessage, isNull);
    });

    test('copyWith updates correctly', () {
      const state = AuthState();
      final updated = state.copyWith(status: AuthStatus.loading);
      expect(updated.status, AuthStatus.loading);
      expect(updated.user, isNull);
    });
  });

  group('AuthRepositoryImpl', () {
    test('is a valid AuthRepository', () {
      expect(AuthRepositoryImpl, isA<Type>());
    });
  });
}
