import 'package:car_register_app/core/error/error_handler.dart';
import 'package:car_register_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('handleException()', () {
    test('returns the same Failure if already a Failure', () {
      const failure = NetworkFailure('already a failure');
      final result = handleException(failure);
      expect(result, equals(failure));
    });

    test('classifies socket exception as NetworkFailure', () {
      final result = handleException(Exception('SocketException: connection refused'));
      expect(result, isA<NetworkFailure>());
    });

    test('classifies connection refused as NetworkFailure', () {
      final result = handleException(Exception('Connection refused'));
      expect(result, isA<NetworkFailure>());
    });

    test('classifies connection timed out as NetworkFailure', () {
      final result = handleException(Exception('Connection timed out'));
      expect(result, isA<NetworkFailure>());
    });

    test('classifies network unreachable as NetworkFailure', () {
      final result = handleException(Exception('Network is unreachable'));
      expect(result, isA<NetworkFailure>());
    });

    test('classifies timeout as NetworkFailure with Arabic message', () {
      final result = handleException(Exception('Timeout'));
      expect(result, isA<NetworkFailure>());
      expect(result.message, contains('مهلة'));
    });

    test('classifies quota exceeded as QuotaFailure', () {
      final result = handleException(Exception('quota exceeded'));
      expect(result, isA<QuotaFailure>());
    });

    test('classifies limit exceeded as QuotaFailure', () {
      final result = handleException(Exception('rate limit exceeded'));
      expect(result, isA<QuotaFailure>());
    });

    test('classifies permission denied as PermissionFailure', () {
      final result = handleException(Exception('Permission denied'));
      expect(result, isA<PermissionFailure>());
    });

    test('classifies unauthorized as PermissionFailure', () {
      final result = handleException(Exception('Unauthorized'));
      expect(result, isA<PermissionFailure>());
    });

    test('classifies access denied as PermissionFailure', () {
      final result = handleException(Exception('Access denied'));
      expect(result, isA<PermissionFailure>());
    });

    test('classifies forbidden as PermissionFailure', () {
      final result = handleException(Exception('Forbidden'));
      expect(result, isA<PermissionFailure>());
    });

    test('classifies not found as NotFoundFailure', () {
      final result = handleException(Exception('Not found'));
      expect(result, isA<NotFoundFailure>());
    });

    test('classifies 404 as NotFoundFailure', () {
      final result = handleException(Exception('404 error'));
      expect(result, isA<NotFoundFailure>());
    });

    test('classifies already exists as DuplicateFailure', () {
      final result = handleException(Exception('already exists'));
      expect(result, isA<DuplicateFailure>());
    });

    test('classifies duplicate as DuplicateFailure', () {
      final result = handleException(Exception('duplicate entry'));
      expect(result, isA<DuplicateFailure>());
    });

    test('classifies unknown exception as UnknownFailure', () {
      final result = handleException(Exception('some random error'));
      expect(result, isA<UnknownFailure>());
    });

    test('is case-insensitive for error matching', () {
      final result = handleException(Exception('SOCKETEXCEPTION'));
      expect(result, isA<NetworkFailure>());
    });

    test('handles null exception gracefully', () {
      final result = handleException(Exception());
      expect(result, isA<UnknownFailure>());
    });

    test('handles empty string exception', () {
      final result = handleException(Exception(''));
      expect(result, isA<UnknownFailure>());
    });
  });
}
