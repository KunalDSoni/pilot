sealed class AppException implements Exception {
  AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;
}

final class NetworkException extends AppException {
  NetworkException(super.message, {super.statusCode});
}

final class AuthException extends AppException {
  AuthException(super.message, {super.statusCode});
}

final class ServerException extends AppException {
  ServerException(super.message, {super.statusCode});
}

final class CacheException extends AppException {
  CacheException(super.message, {super.statusCode});
}

final class ValidationException extends AppException {
  ValidationException(super.message, {super.statusCode, this.errors});

  final Map<String, List<String>>? errors;
}
