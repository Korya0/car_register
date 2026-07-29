import 'package:car_register_app/core/error/failure.dart';
import 'package:car_register_app/core/error/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result<T> sealed class', () {
    group('Success', () {
      test('creates Success with data', () {
        const result = Result<int>.success(42);
        expect(result, isA<Success<int>>());
      });

      test('when() calls success callback with correct data', () {
        const result = Result<String>.success('hello');
        final value = result.when(
          success: (data) => 'Got: $data',
          failure: (_) => 'Failed',
        );
        expect(value, equals('Got: hello'));
      });

      test('equality returns true for same data', () {
        const result1 = Success<String>('test');
        const result2 = Success<String>('test');
        expect(result1, equals(result2));
      });

      test('equality returns false for different data', () {
        const result1 = Success<String>('test1');
        const result2 = Success<String>('test2');
        expect(result1, isNot(equals(result2)));
      });

      test('hashCode is consistent with equality', () {
        const result1 = Success<String>('test');
        const result2 = Success<String>('test');
        expect(result1.hashCode, equals(result2.hashCode));
      });
    });

    group('FailureResult', () {
      test('creates FailureResult with failure', () {
        const result = Result<int>.failure(UnknownFailure('error'));
        expect(result, isA<FailureResult<int>>());
      });

      test('when() calls failure callback with correct failure', () {
        const failure = UnknownFailure('error');
        const result = Result<String>.failure(failure);
        final value = result.when(
          success: (_) => 'Success',
          failure: (f) => 'Failed: ${f.message}',
        );
        expect(value, equals('Failed: error'));
      });

      test('equality returns true for same failure', () {
        const failure = UnknownFailure('test');
        const result1 = FailureResult<String>(failure);
        const result2 = FailureResult<String>(failure);
        expect(result1, equals(result2));
      });

      test('equality returns false for different failures', () {
        const result1 = FailureResult<String>(UnknownFailure('err1'));
        const result2 = FailureResult<String>(UnknownFailure('err2'));
        expect(result1, isNot(equals(result2)));
      });

      test('hashCode is consistent with equality', () {
        const failure = UnknownFailure('test');
        const result1 = FailureResult<String>(failure);
        const result2 = FailureResult<String>(failure);
        expect(result1.hashCode, equals(result2.hashCode));
      });
    });

    group('when() method', () {
      test('applies success branch on Success', () {
        const result = Result<int>.success(100);
        final output = result.when(
          success: (data) => data * 2,
          failure: (_) => -1,
        );
        expect(output, equals(200));
      });

      test('applies failure branch on FailureResult', () {
        const result = Result<int>.failure(UnknownFailure());
        final output = result.when(success: (data) => data, failure: (_) => -1);
        expect(output, equals(-1));
      });
    });
  });
}
