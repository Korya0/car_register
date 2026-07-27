import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class Failure {
  final String message;

  const Failure(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = AppStrings.failureNetwork]);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = AppStrings.failureServer]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = AppStrings.failureCache]);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = AppStrings.failurePermission]);
}

class QuotaFailure extends Failure {
  const QuotaFailure([super.message = AppStrings.failureQuota]);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = AppStrings.failureNotFound]);
}

class DuplicateFailure extends Failure {
  const DuplicateFailure([super.message = AppStrings.failureDuplicate]);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = AppStrings.failureUnknown]);
}
