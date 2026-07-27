import 'package:car_register_app/core/error/failure.dart';
import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';

enum AppPageView { add, list }

sealed class CarRegisterState {
  const CarRegisterState();
}

class CarRegisterInitial extends CarRegisterState {
  const CarRegisterInitial();
}

class CarRegisterLoading extends CarRegisterState {
  const CarRegisterLoading();
}

class CarRegisterLoaded extends CarRegisterState {
  final List<CarNumberModel> carNumbers;
  final bool isAddingNumber;
  final bool isDeletingNumber;
  final AppPageView currentPage;
  final String? successMessage;

  const CarRegisterLoaded({
    this.carNumbers = const [],
    this.isAddingNumber = false,
    this.isDeletingNumber = false,
    this.currentPage = AppPageView.add,
    this.successMessage,
  });

  CarRegisterLoaded copyWith({
    List<CarNumberModel>? carNumbers,
    bool? isAddingNumber,
    bool? isDeletingNumber,
    AppPageView? currentPage,
    String? successMessage,
  }) {
    return CarRegisterLoaded(
      carNumbers: carNumbers ?? this.carNumbers,
      isAddingNumber: isAddingNumber ?? this.isAddingNumber,
      isDeletingNumber: isDeletingNumber ?? this.isDeletingNumber,
      currentPage: currentPage ?? this.currentPage,
      successMessage: successMessage,
    );
  }
}

class CarRegisterFailure extends CarRegisterState {
  final Failure failure;
  final List<CarNumberModel> carNumbers;
  final AppPageView currentPage;

  const CarRegisterFailure({
    required this.failure,
    this.carNumbers = const [],
    this.currentPage = AppPageView.add,
  });
}
