import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/router/app_router.dart';
import 'features/car_register/presentation/cubit/car_register_cubit.dart';
import 'features/car_register/data/services/google_sheets_service.dart';
import 'core/utils/connectivity_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CarRegisterCubit>(
          create: (context) => CarRegisterCubit(
            sheetsService: GoogleSheetsService(),
            connectivityService: ConnectivityService(),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'Car Register App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router,
        builder: (context, child) {
          // Force RTL for Arabic
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
      ),
    );
  }
}
