import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';
import '../errors/app_exception.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

class ApiClient {
  ApiClient() {
    _init();
  }

  late final Dio _dio;
  final _storage = const FlutterSecureStorage();

  void _init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: '${ApiConstants.baseUrl}${ApiConstants.apiPrefix}',
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
  }) async {
    try {
      return await _dio.post<T>(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
  }) async {
    try {
      return await _dio.put<T>(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> delete<T>(String path) async {
    try {
      return await _dio.delete<T>(path);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  AppException _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        return NetworkException(
          'No internet connection. Please check your network.',
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 500;
        final message = e.response?.data?['detail'] ?? 'Something went wrong';
        if (statusCode == 401) {
          return AuthException(message.toString(), statusCode: statusCode);
        }
        if (statusCode == 422) {
          return ValidationException(
            message.toString(),
            statusCode: statusCode,
          );
        }
        return ServerException(message.toString(), statusCode: statusCode);
      case DioExceptionType.cancel:
        return NetworkException('Request was cancelled.');
      default:
        return ServerException('An unexpected error occurred.');
    }
  }
}
