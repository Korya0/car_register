// injection.dart
import 'package:car_register_app/core/services/network/connectivity_service.dart';
import 'package:car_register_app/core/services/shared_pref/shared_pref.dart';
import 'package:car_register_app/features/car_register/data/google_sheets_service.dart';
import 'package:car_register_app/features/car_register/presentation/cubit/car_register_cubit.dart';
import 'package:car_register_app/features/loc_app/data/datasources/firebase_datasource.dart';
import 'package:car_register_app/features/loc_app/data/repositories/firebase_repository.dart';
import 'package:car_register_app/features/loc_app/presentation/cubits/lock_app_cubit.dart';
import 'package:car_register_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setupInjector() async {
  await _initExternalServices();
  await _registerServices();
  _registerRepositories();
  _registerDataSources();
  _registerCubits();
}

Future<void> _initExternalServices() async {
  await SharedPref.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> _registerServices() async {
  sl.registerLazySingleton<SharedPrefService>(() => SharedPrefService());
  sl.registerLazySingleton<FirebaseService>(() => FirebaseService());
  sl.registerLazySingleton<GoogleSheetsService>(() => GoogleSheetsService());
  sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
}

void _registerRepositories() {
  sl.registerLazySingleton<LockAppRepository>(
    () => LockAppRepository(sl<LockAppDataSource>()),
  );
}

void _registerDataSources() {
  sl.registerLazySingleton<LockAppDataSource>(() => LockAppDataSource());
}

void _registerCubits() {
  sl.registerFactory<CarRegisterCubit>(
    () => CarRegisterCubit(
      sheetsService: sl<GoogleSheetsService>(),
      connectivityService: sl<ConnectivityService>(),
    ),
  );

  sl.registerFactory<LockAppCubit>(() => LockAppCubit(sl<LockAppRepository>()));
}

/// Service for handling shared preferences operations
class SharedPrefService {
  // Add shared preferences methods here
}

/// Service for handling Firebase operations
class FirebaseService {
  // Add Firebase methods here
}
