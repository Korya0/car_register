import 'package:car_register_app/core/services/shared_pref/shared_pref.dart';
import 'package:car_register_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setupInjector() async {
  await _initServices();
}

Future<void> _initServices() async {
  // SharedPref Service
  sl.registerLazySingleton<SharedPrefService>(() => SharedPrefService());
  await sl<SharedPrefService>().init();

  // Firebase Service
  sl.registerLazySingleton<FirebaseService>(() => FirebaseService());
  await sl<FirebaseService>().init(); // 👈 دي اللي كانت ناقصة
}

/// Shared Preferences Service
class SharedPrefService {
  Future<void> init() async {
    await SharedPref.initialize();
  }
}

/// Firebase Service
class FirebaseService {
  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
