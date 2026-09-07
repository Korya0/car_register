import 'dart:async';
import 'package:car_register_app/core/utils/app_logger.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  AppLogger.enabled = false;
  await testMain();
}
