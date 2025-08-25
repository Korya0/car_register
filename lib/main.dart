// main.dart
import 'package:car_register_app/core/resources/theme/app_theme.dart';
import 'package:car_register_app/core/utils/bloc/bloc_observer.dart';
import 'package:car_register_app/core/utils/di/injuction.dart';
import 'package:car_register_app/features/loc_app/presentation/cubits/lock_app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/resources/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjector();
  Bloc.observer = AppBlocObserver();

  runApp(
    const MyApp(),
    //DevicePreview(enabled: !kReleaseMode, builder: (context) => MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LockAppCubit>(
          create: (context) => sl<LockAppCubit>()..loadBoolean(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp.router(
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme(),
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },
        ),
      ),
    );
  }
}
