import 'package:car_ai/core/errors/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppException', () {
    test('NetworkException has correct message', () {
      final exception = NetworkException('Connection failed');
      expect(exception.message, 'Connection failed');
      expect(exception, isA<AppException>());
    });

    test('AuthException has correct status code', () {
      final exception = AuthException('Unauthorized', statusCode: 401);
      expect(exception.statusCode, 401);
      expect(exception.message, 'Unauthorized');
    });

    test('ServerException has correct message', () {
      final exception = ServerException('Internal error');
      expect(exception.message, 'Internal error');
    });

    test('ValidationException has errors map', () {
      final exception = ValidationException(
        'Validation failed',
        errors: {'email': ['Invalid email']},
      );
      expect(exception.errors, isNotNull);
      expect(exception.errors!['email'], contains('Invalid email'));
    });

    test('CacheException has correct type', () {
      final exception = CacheException('Cache miss');
      expect(exception, isA<AppException>());
    });
  });
}
