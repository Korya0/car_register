import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/core/style/font/app_text_styles.dart';
import 'package:car_register_app/core/utils/app_logger.dart';
import 'package:car_register_app/core/utils/injuction.dart';
import 'package:car_register_app/core/widgets/animate_do.dart';
import 'package:car_register_app/core/widgets/app_bottom_nav_bar.dart';
import 'package:car_register_app/core/widgets/toast_message.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_cubit.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_state.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/home_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  final CarRegisterCubit? cubit;

  const HomeView({super.key, this.cubit});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final CarRegisterCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = widget.cubit ?? sl<CarRegisterCubit>();
    AppLogger.debug('HomeView: initState');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _cubit.initializeApp();
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CarRegisterCubit>.value(
      value: _cubit,
      child: BlocListener<CarRegisterCubit, CarRegisterState>(
        listener: (context, state) {
          if (state case CarRegisterLoaded(
            successMessage: final msg?,
          ) when msg.isNotEmpty) {
            ToastMessage.success(context, msg);
            context.read<CarRegisterCubit>().clearSuccessMessage();
          }
          if (state case CarRegisterFailure(failure: final f)) {
            ToastMessage.error(context, f.message);
            context.read<CarRegisterCubit>().clearFailure();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: CustomFadeInDown(
              duration: 500,
              child: Text(
                AppStrings.appTitle,
                style: AppTextStyles.appBarTitle,
              ),
            ),
            centerTitle: true,
          ),
          body: const HomeBody(),
          bottomNavigationBar: const AppBottomNavBar(),
        ),
      ),
    );
  }
}
