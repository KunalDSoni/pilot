import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_exception.dart';
import '../entities/auth_tokens.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<AppException, AuthTokens>> login(String email, String password);
  Future<Either<AppException, AuthTokens>> register(
    String name,
    String email,
    String password,
    String? phone,
  );
  Future<Either<AppException, void>> logout();
  Future<Either<AppException, User?>> getCurrentUser();
  Future<bool> isAuthenticated();
}
