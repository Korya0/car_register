import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure sealed class', () {
    test('equality returns true for same message', () {
      const failure1 = NetworkFailure('test');
      const failure2 = NetworkFailure('test');
      expect(failure1, equals(failure2));
    });

    test('equality returns false for different messages', () {
      const failure1 = NetworkFailure('test1');
      const failure2 = NetworkFailure('test2');
      expect(failure1, isNot(equals(failure2)));
    });

    test('equality depends only on message, not runtime type', () {
      // Failure equality checks message only, not the concrete type
      const networkFailure = NetworkFailure('same message');
      const serverFailure = ServerFailure('same message');
      expect(networkFailure, equals(serverFailure));
    });

    test('equality returns false for different messages on different types', () {
      const failure1 = NetworkFailure('msg1');
      const failure2 = ServerFailure('msg2');
      expect(failure1, isNot(equals(failure2)));
    });

    test('hashCode is consistent with equality', () {
      const failure1 = CacheFailure('test');
      const failure2 = CacheFailure('test');
      expect(failure1.hashCode, equals(failure2.hashCode));
    });
  });

  group('NetworkFailure', () {
    test('has correct default message', () {
      const failure = NetworkFailure();
      expect(failure.message, equals(AppStrings.failureNetwork));
    });
  });

  group('ServerFailure', () {
    test('has correct default message', () {
      const failure = ServerFailure();
      expect(failure.message, equals(AppStrings.failureServer));
    });
  });

  group('CacheFailure', () {
    test('has correct default message', () {
      const failure = CacheFailure();
      expect(failure.message, equals(AppStrings.failureCache));
    });
  });

  group('ValidationFailure', () {
    test('uses provided message', () {
      const failure = ValidationFailure('Invalid input');
      expect(failure.message, equals('Invalid input'));
    });
  });

  group('PermissionFailure', () {
    test('has correct default message', () {
      const failure = PermissionFailure();
      expect(failure.message, equals(AppStrings.failurePermission));
    });
  });

  group('QuotaFailure', () {
    test('has correct default message', () {
      const failure = QuotaFailure();
      expect(failure.message, equals(AppStrings.failureQuota));
    });
  });

  group('NotFoundFailure', () {
    test('has correct default message', () {
      const failure = NotFoundFailure();
      expect(failure.message, equals(AppStrings.failureNotFound));
    });
  });

  group('DuplicateFailure', () {
    test('has correct default message', () {
      const failure = DuplicateFailure();
      expect(failure.message, equals(AppStrings.failureDuplicate));
    });
  });

  group('UnknownFailure', () {
    test('has correct default message', () {
      const failure = UnknownFailure();
      expect(failure.message, equals(AppStrings.failureUnknown));
    });
  });

  group('Custom message override', () {
    test('all failure types accept custom message', () {
      const failures = <Failure>[
        NetworkFailure('custom'),
        ServerFailure('custom'),
        CacheFailure('custom'),
        ValidationFailure('custom'),
        PermissionFailure('custom'),
        QuotaFailure('custom'),
        NotFoundFailure('custom'),
        DuplicateFailure('custom'),
        UnknownFailure('custom'),
      ];
      for (final f in failures) {
        expect(f.message, equals('custom'));
      }
    });
  });

  group('all failure subclasses instantiate', () {
    test('all concrete types can be created', () {
      final failures = <Failure>[
        const NetworkFailure(),
        const ServerFailure(),
        const CacheFailure(),
        const ValidationFailure(''),
        const PermissionFailure(),
        const QuotaFailure(),
        const NotFoundFailure(),
        const DuplicateFailure(),
        const UnknownFailure(),
      ];
      for (final f in failures) {
        expect(f, isA<Failure>());
      }
    });
  });
}
