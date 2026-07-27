import 'package:car_register_app/core/utils/app_logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'failure.dart';

Failure handleException(Object exception, [StackTrace? stackTrace]) {
  if (exception is Failure) {
    return exception;
  }

  AppLogger.warn('Handling exception: $exception', stackTrace: stackTrace);

  final errorString = exception.toString().toLowerCase();

  if (errorString.contains('socketexception') ||
      errorString.contains('connection refused') ||
      errorString.contains('connection closed before full header') ||
      errorString.contains('network is unreachable') ||
      errorString.contains('connection timed out')) {
    return const NetworkFailure();
  }

  if (errorString.contains('timeout') || errorString.contains('timed out')) {
    return const NetworkFailure('انتهت مهلة الاتصال، حاول مرة أخرى');
  }

  if (errorString.contains('quota') || errorString.contains('limit') || errorString.contains('exceeded') || errorString.contains('rate limit')) {
    return const QuotaFailure();
  }

  if (errorString.contains('permission') || errorString.contains('unauthorized') || errorString.contains('access denied') || errorString.contains('forbidden')) {
    return const PermissionFailure();
  }

  if (errorString.contains('not found') || errorString.contains('404')) {
    return const NotFoundFailure();
  }

  if (errorString.contains('already exists') || errorString.contains('duplicate')) {
    return const DuplicateFailure();
  }

  AppLogger.error('Unhandled exception type, returning UnknownFailure', error: exception, stackTrace: stackTrace);
  return const UnknownFailure();
}

Future<bool> isConnected() async {
  try {
    final result = await Connectivity().checkConnectivity();
    final connected = result != ConnectivityResult.none;
    AppLogger.debug('Network connectivity check: $connected');
    return connected;
  } catch (_) {
    AppLogger.warn('Network connectivity check failed, assuming not connected');
    return false;
  }
}
