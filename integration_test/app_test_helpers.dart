import 'dart:io';

import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/core/error/failure.dart';
import 'package:car_register_app/core/error/result.dart';
import 'package:car_register_app/core/router/app_router.dart';
import 'package:car_register_app/core/utils/app_logger.dart';
import 'package:car_register_app/features/car_register/data/datasources/car_number_local_datasource.dart';
import 'package:car_register_app/features/car_register/data/datasources/car_number_remote_datasource.dart';
import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';
import 'package:car_register_app/features/car_register/data/repositories/car_number_repository.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';

final sl = GetIt.instance;

// ---------------------------------------------------------------------------
// Mock control flags
// ---------------------------------------------------------------------------

/// Configurable mock for testing error/loading states.
bool mockRemoteShouldFailOnInitialize = false;
int mockRemoteInitializeDelayMs = 0;

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class _MockSharedPref {
  final Map<String, String> _store = <String, String>{};

  String? getString(String key) => _store[key];

  Future<void> setString(String key, String value) async {
    _store[key] = value;
  }

  Future<void> clear() async => _store.clear();
}

class _MockRemoteDataSource implements CarNumberRemoteDataSource {
  @override
  Future<Result<void>> initialize() async {
    if (mockRemoteInitializeDelayMs > 0) {
      await Future<void>.delayed(
        Duration(milliseconds: mockRemoteInitializeDelayMs),
      );
    }
    if (mockRemoteShouldFailOnInitialize) {
      return const Result.failure(NetworkFailure());
    }
    return const Result.success(null);
  }

  @override
  Future<Result<List<CarNumberModel>>> getAllNumbers({
    bool forceRefresh = false,
  }) async => const Result.success([]);

  @override
  Future<Result<bool>> addNumber(CarNumberModel number) async =>
      const Result.success(true);

  @override
  Future<Result<bool>> deleteNumber(String number) async =>
      const Result.success(true);

  @override
  Future<Result<bool>> deleteNumbers(List<String> numbers) async =>
      const Result.success(true);

  @override
  Future<Result<bool>> clearAll() async => const Result.success(true);

  @override
  Future<Result<bool>> numberExists(String number) async =>
      const Result.success(false);
}

/// Reset all mock configuration flags to their defaults.
void resetMockConfig() {
  mockRemoteShouldFailOnInitialize = false;
  mockRemoteInitializeDelayMs = 0;
}

// ---------------------------------------------------------------------------
// Platform channel mocks (path_provider for google_fonts, integration_test)
// ---------------------------------------------------------------------------

final List<Directory> _tempDirs = [];

/// Set up mock platform channels required by dependencies (e.g. google_fonts)
/// and suppress the harmless `integration_test` plugin warning.
void setUpMockPlatformChannels() {
  AppLogger.enabled = false;
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
    ..setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'getApplicationSupportDirectory') {
          final dir = Directory.systemTemp.createTemp('google_fonts_test_');
          _tempDirs.add(await dir);
          return (await dir).path;
        }
        return null;
      },
    )
    ..setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/integration_test'),
      (MethodCall methodCall) async => true,
    );
}

/// Remove all temp directories created by [setUpMockPlatformChannels].
void cleanUpTempDirs() {
  for (final dir in _tempDirs) {
    try {
      dir.deleteSync(recursive: true);
    } catch (_) {}
  }
  _tempDirs.clear();
}

/// Initialise the integration test binding and mock platform channels
/// so warnings (integration_test plugin, path_provider) are silenced.
void setUpIntegrationTestBinding() {
  AppLogger.enabled = false;
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpMockPlatformChannels();
}

/// Pump the test app on a phone-sized surface (430×932) so the keypad
/// is fully visible.  Must be called inside a test (not in setUp / main).
Future<void> pumpTestApp(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(540, 1400));
  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
  });
  await tester.pumpWidget(buildTestApp());
}

// ---------------------------------------------------------------------------
// Dependency injection
// ---------------------------------------------------------------------------

Future<void> setupTestInjector() async {
  setUpMockPlatformChannels();
  final locator = GetIt.instance;
  await locator.reset();
  locator
    ..registerSingleton<_MockSharedPref>(_MockSharedPref())
    ..registerLazySingleton<CarNumberLocalDataSource>(
      () => InMemoryCarNumberLocalDataSource(locator<_MockSharedPref>()),
    )
    ..registerLazySingleton<CarNumberRemoteDataSource>(
      _MockRemoteDataSource.new,
    )
    ..registerLazySingleton<CarNumberRepository>(
      () => CarNumberRepository(
        locator<CarNumberRemoteDataSource>(),
        locator<CarNumberLocalDataSource>(),
      ),
    )
    ..registerFactory<CarRegisterCubit>(
      () => CarRegisterCubit(locator<CarNumberRepository>()),
    );
}

// ---------------------------------------------------------------------------
// In-memory local datasource
// ---------------------------------------------------------------------------

class InMemoryCarNumberLocalDataSource implements CarNumberLocalDataSource {
  // ignore: library_private_types_in_public_api
  InMemoryCarNumberLocalDataSource(this._sharedPref);
  final _MockSharedPref _sharedPref;
  static const String _storageKey = 'car_numbers';

  Future<List<CarNumberModel>> _getCache() async {
    final jsonData = _sharedPref.getString(_storageKey);
    if (jsonData != null) {
      final decoded = jsonData.split('|');
      return decoded
          .where((s) => s.isNotEmpty)
          .map((s) => CarNumberModel(number: s))
          .toList();
    }
    return [];
  }

  Future<void> _setCache(List<CarNumberModel> cache) async {
    final jsonList = cache.map((e) => e.number).join('|');
    await _sharedPref.setString(_storageKey, jsonList);
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<List<CarNumberModel>> getAllNumbers() async => _getCache();

  @override
  Future<bool> addNumber(CarNumberModel number) async {
    final cache = await _getCache();
    if (cache.any((e) => e.number == number.number)) return false;
    cache.add(number);
    await _setCache(cache);
    return true;
  }

  @override
  Future<bool> deleteNumber(String number) async {
    final cache = await _getCache();
    final initialLength = cache.length;
    cache.removeWhere((e) => e.number == number);
    if (cache.length < initialLength) {
      await _setCache(cache);
      return true;
    }
    return false;
  }

  @override
  Future<bool> deleteNumbers(List<String> numbers) async {
    final cache = await _getCache();
    final targetSet = numbers.toSet();
    final initialLength = cache.length;
    cache.removeWhere((e) => targetSet.contains(e.number));
    if (cache.length < initialLength) {
      await _setCache(cache);
      return true;
    }
    return false;
  }

  @override
  Future<bool> clearAll() async {
    await _setCache([]);
    return true;
  }

  @override
  Future<bool> numberExists(String number) async {
    final cache = await _getCache();
    return cache.any((e) => e.number == number);
  }
}

// ---------------------------------------------------------------------------
// App widget
// ---------------------------------------------------------------------------

Widget buildTestApp() {
  return ScreenUtilInit(
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, _) => Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

Future<void> clearStorage() async {
  final mockPref = GetIt.instance<_MockSharedPref>();
  await mockPref.clear();
}

// ---------------------------------------------------------------------------
// Shared test helpers
// ---------------------------------------------------------------------------

Future<void> enterNumberViaKeypad(WidgetTester tester, String number) async {
  for (final digit in number.split('')) {
    await tester.tap(find.text(digit).last);
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> goToListTab(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.list).first);
  await tester.pumpAndSettle();
}

Future<void> goToAddTab(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.add).first);
  await tester.pumpAndSettle();
}

Future<void> addCarNumber(WidgetTester tester, String number) async {
  await enterNumberViaKeypad(tester, number);
  await tester.ensureVisible(find.text(AppStrings.savePlate));
  await tester.pump();
  await tester.tap(find.text(AppStrings.savePlate));
  await tester.pump(const Duration(seconds: 4));
}

Future<void> addCarNumberAndVerifyOnList(
  WidgetTester tester,
  String number,
) async {
  await addCarNumber(tester, number);
  await goToListTab(tester);
  expect(find.text(number), findsOneWidget);
}
