import 'package:car_register_app/core/services/local/shared_pref_local_storage.dart';
import 'package:car_register_app/features/car_register/data/datasources/car_number_local_datasource.dart';
import 'package:car_register_app/features/car_register/data/datasources/car_number_remote_datasource.dart';
import 'package:car_register_app/features/car_register/data/datasources/gsheets_car_number_remote_datasource_impl.dart';
import 'package:car_register_app/features/car_register/data/datasources/shared_pref_car_number_local_datasource_impl.dart';
import 'package:car_register_app/features/car_register/data/repositories/car_number_repository.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setupInjector() async {
  // Core Services
  sl.registerLazySingleton<SharedPref>(() => SharedPref());

  // Data Sources
  sl.registerLazySingleton<CarNumberLocalDataSource>(
    () => SharedPrefCarNumberLocalDataSourceImpl(sl<SharedPref>()),
  );
  sl.registerLazySingleton<CarNumberRemoteDataSource>(
    () => GSheetsCarNumberRemoteDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<CarNumberRepository>(
    () => CarNumberRepository(
      sl<CarNumberRemoteDataSource>(),
      sl<CarNumberLocalDataSource>(),
    ),
  );

  // Cubit
  sl.registerFactory<CarRegisterCubit>(
    () => CarRegisterCubit(sl<CarNumberRepository>()),
  );
}
