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
  sl
    ..registerLazySingleton<SharedPref>(SharedPref.new)
    ..registerLazySingleton<CarNumberLocalDataSource>(
      () => SharedPrefCarNumberLocalDataSourceImpl(sl<SharedPref>()),
    )
    ..registerLazySingleton<CarNumberRemoteDataSource>(
      GSheetsCarNumberRemoteDataSourceImpl.new,
    )
    ..registerLazySingleton<CarNumberRepository>(
      () => CarNumberRepository(
        sl<CarNumberRemoteDataSource>(),
        sl<CarNumberLocalDataSource>(),
      ),
    )
    ..registerFactory<CarRegisterCubit>(
      () => CarRegisterCubit(sl<CarNumberRepository>()),
    );
}
