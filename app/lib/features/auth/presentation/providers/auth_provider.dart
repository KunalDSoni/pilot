import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    apiClient: ref.watch(apiClientProvider),
    secureStorage: const FlutterSecureStorage(),
  );
});

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  Future<void> checkAuth() async {
    final isAuth = await _repository.isAuthenticated();
    if (isAuth) {
      state = state.copyWith(status: AuthStatus.authenticated);
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    final result = await _repository.login(email, password);
    result.fold(
      (error) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: error.message,
        );
      },
      (tokens) {
        state = state.copyWith(status: AuthStatus.authenticated);
      },
    );
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String? phone,
  ) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    final result = await _repository.register(name, email, password, phone);
    result.fold(
      (error) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: error.message,
        );
      },
      (tokens) {
        state = state.copyWith(status: AuthStatus.authenticated);
      },
    );
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
