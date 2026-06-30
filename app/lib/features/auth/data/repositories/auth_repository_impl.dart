import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/network/api_client.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required ApiClient apiClient,
    required FlutterSecureStorage secureStorage,
  })  : _api = apiClient,
        _storage = secureStorage;

  final ApiClient _api;
  final FlutterSecureStorage _storage;

  @override
  Future<Either<AppException, AuthTokens>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await _api.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      final data = response.data as Map<String, dynamic>;
      final tokens = AuthTokens.fromJson(data);
      await _saveTokens(tokens);
      return Right(tokens);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<AppException, AuthTokens>> register(
    String name,
    String email,
    String password,
    String? phone,
  ) async {
    try {
      final response = await _api.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
      });
      final data = response.data as Map<String, dynamic>;
      final tokens = AuthTokens.fromJson(data);
      await _saveTokens(tokens);
      return Right(tokens);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<AppException, void>> logout() async {
    try {
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'refresh_token');
      return const Right(null);
    } catch (e) {
      return Left(ServerException('Failed to logout'));
    }
  }

  @override
  Future<Either<AppException, User?>> getCurrentUser() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null) {
        return const Right(null);
      }
      return Right(null);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException('Failed to get current user'));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'auth_token');
    return token != null;
  }

  Future<void> _saveTokens(AuthTokens tokens) async {
    await _storage.write(key: 'auth_token', value: tokens.accessToken);
    await _storage.write(key: 'refresh_token', value: tokens.refreshToken);
  }
}
