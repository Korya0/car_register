import 'package:car_register_app/core/error/result.dart';
import 'package:car_register_app/features/car_register/data/datasources/car_number_local_datasource.dart';
import 'package:car_register_app/features/car_register/data/datasources/car_number_remote_datasource.dart';
import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';
import 'package:car_register_app/features/car_register/data/repositories/car_number_repository.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_cubit.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_state.dart';
import 'package:car_register_app/features/car_register/presentation/views/home_view.dart' show HomeView;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class _MockRemoteDataSource implements CarNumberRemoteDataSource {
  @override
  Future<Result<void>> initialize() async => const Result.success(null);

  @override
  Future<Result<List<CarNumberModel>>> getAllNumbers({
    bool forceRefresh = false,
  }) async =>
      const Result.success([]);

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

class _MockLocalDataSource implements CarNumberLocalDataSource {
  @override
  Future<void> initialize() async {}

  @override
  Future<List<CarNumberModel>> getAllNumbers() async => [];

  @override
  Future<bool> addNumber(CarNumberModel number) async => true;

  @override
  Future<bool> deleteNumber(String number) async => true;

  @override
  Future<bool> deleteNumbers(List<String> numbers) async => true;

  @override
  Future<bool> clearAll() async => true;

  @override
  Future<bool> numberExists(String number) async => false;
}

/// A test-friendly [CarRegisterCubit] that:
/// - Tracks method calls for verification
/// - Allows direct state emission via [emitState]
/// - Uses dummy datasources so no real I/O occurs
class MockCarRegisterCubit extends CarRegisterCubit {
  MockCarRegisterCubit()
      : super(
          CarNumberRepository(_MockRemoteDataSource(), _MockLocalDataSource()),
        );

  final List<String> addNumberCalls = [];
  final List<String> deleteNumberCalls = [];
  final List<List<String>> deleteMultipleCalls = [];
  int clearAllCalls = 0;
  final List<AppPageView> setCurrentPageCalls = [];
  int initializeAppCalls = 0;

  /// Directly emit a state (bypasses repository logic)
  void emitState(CarRegisterState state) => emit(state);

  @override
  Future<void> addCarNumber(String number) async {
    addNumberCalls.add(number);
  }

  @override
  Future<void> deleteCarNumber(String number) async {
    deleteNumberCalls.add(number);
  }

  @override
  Future<void> deleteMultiple(List<String> numbers) async {
    deleteMultipleCalls.add(numbers);
  }

  @override
  Future<void> clearAll() async {
    clearAllCalls++;
  }

  @override
  void setCurrentPage(AppPageView page) {
    setCurrentPageCalls.add(page);
    super.setCurrentPage(page);
  }

  @override
  Future<void> initializeApp() async {
    initializeAppCalls++;
  }
}

/// Wraps [child] with a [MaterialApp] containing a [Scaffold], plus
/// [ScreenUtilInit] for flutter_screenutil support. Use this for widgets
/// that do NOT create their own Scaffold.
Widget wrapWithApp(Widget child) {
  return _buildScreenUtilApp(child, null, true);
}

/// Like [wrapWithApp] but also provides a [BlocProvider] for [CarRegisterCubit].
Widget wrapWithBloc(Widget child, CarRegisterCubit cubit) {
  return _buildScreenUtilApp(child, cubit, true);
}

/// Wraps [child] with [ScreenUtilInit] + [MaterialApp] but NO extra Scaffold.
/// Use this for widgets that already contain a Scaffold (e.g. [HomeView]).
Widget wrapWithProviders(Widget child) {
  return _buildScreenUtilApp(child, null, false);
}

Widget _buildScreenUtilApp(
  Widget child,
  CarRegisterCubit? cubit,
  bool wrapInScaffold,
) {
  var body = child;
  if (cubit != null) {
    body = BlocProvider<CarRegisterCubit>.value(
      value: cubit,
      child: child,
    );
  }
  if (wrapInScaffold) {
    body = Scaffold(body: body);
  }

  return ScreenUtilInit(
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, _) => MaterialApp(home: body),
    child: const SizedBox.shrink(),
  );
}
