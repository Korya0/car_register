import 'package:car_register_app/core/constants/app_assets.dart';
import 'package:car_register_app/core/resources/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // ignore: deprecated_member_use
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Lottie.asset(
          AppAssets.loaderLottieInfinit,

          delegates: LottieDelegates(
            values: [
              // replace ALL fill colors with your primary color
              ValueDelegate.colorFilter(
                const ['**'], // ** = target all layers
                value: const ColorFilter.mode(
                  AppColors.primary, // your custom color
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
        //CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(color: AppColors.white),
      ),
    );
  }
}
