import 'package:car_register_app/core/router/app_router.dart';
import 'package:car_register_app/core/style/theme/app_colors.dart';
import 'package:car_register_app/core/style/theme/app_theme.dart';
import 'package:car_register_app/core/utils/injuction.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjector();
  runApp(
    kIsWeb && kDebugMode
        ? DevicePreview(
            builder: (context) {
              return const MyApp();
            },
          )
        : const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme(),
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: SkeletonizerConfig(
              data: SkeletonizerConfigData(
                effect: ShimmerEffect(
                  begin: AlignmentDirectional.topCenter,
                  end: AlignmentDirectional.bottomCenter,
                  baseColor: AppColors.textAndIconPrimary.withValues(alpha: 0.08),
                  highlightColor: AppColors.textAndIconPrimary.withValues(alpha: 0.18),
                ),
              ),
              child: child!,
            ),
          );
        },
      ),
    );
  }
}
