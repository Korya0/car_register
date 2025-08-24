// ignore_for_file: unused_local_variable

import 'package:car_register_app/core/utils/connectivity_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/google_sheets_service.dart';

// States
abstract class CarRegisterState extends Equatable {
  const CarRegisterState();

  @override
  List<Object?> get props => [];
}

class CarRegisterInitial extends CarRegisterState {}

class CarRegisterLoading extends CarRegisterState {}

class CarRegisterLoaded extends CarRegisterState {
  final List<String> carNumbers;
  final bool isConnected;
  final String? successMessage;
  final bool isAddingNumber;
  final bool isDeletingNumber;

  const CarRegisterLoaded({
    required this.carNumbers,
    required this.isConnected,
    this.successMessage,
    this.isAddingNumber = false,
    this.isDeletingNumber = false,
  });

  @override
  List<Object?> get props => [
    carNumbers,
    isConnected,
    successMessage,
    isAddingNumber,
    isDeletingNumber,
  ];

  CarRegisterLoaded copyWith({
    List<String>? carNumbers,
    bool? isConnected,
    String? successMessage,
    bool? isAddingNumber,
    bool? isDeletingNumber,
  }) {
    return CarRegisterLoaded(
      carNumbers: carNumbers ?? this.carNumbers,
      isConnected: isConnected ?? this.isConnected,
      successMessage: successMessage,
      isAddingNumber: isAddingNumber ?? this.isAddingNumber,
      isDeletingNumber: isDeletingNumber ?? this.isDeletingNumber,
    );
  }
}

class CarRegisterError extends CarRegisterState {
  final String message;

  const CarRegisterError(this.message);

  @override
  List<Object?> get props => [message];
}

class CarRegisterCubit extends Cubit<CarRegisterState> {
  final GoogleSheetsService _sheetsService;
  final ConnectivityService _connectivityService;

  CarRegisterCubit({
    required GoogleSheetsService sheetsService,
    required ConnectivityService connectivityService,
  }) : _sheetsService = sheetsService,
       _connectivityService = connectivityService,
       super(CarRegisterInitial());

  Future<void> initializeApp() async {
    emit(CarRegisterLoading());

    try {
      _connectivityService.initialize();

      final sheetsInitialized = await _sheetsService.initialize();
      if (!sheetsInitialized) {
        emit(const CarRegisterError('فشل في تهيئة Google Sheets'));
        return;
      }

      await _loadCarNumbers();
    } catch (e) {
      emit(CarRegisterError('حدث خطأ أثناء التهيئة: $e'));
    }
  }

  Future<void> addCarNumber(String number) async {
    if (state is CarRegisterLoaded) {
      final currentState = state as CarRegisterLoaded;

      // Show adding loading state
      emit(currentState.copyWith(isAddingNumber: true));

      // Check connectivity
      if (!_connectivityService.isConnected) {
        emit(currentState.copyWith(isAddingNumber: false));
        emit(CarRegisterError('مطلوب اتصال بالإنترنت'));
        await _loadCarNumbers();
        return;
      }

      // Validate input (digits only)
      if (!RegExp(r'^\d+$').hasMatch(number)) {
        emit(currentState.copyWith(isAddingNumber: false));
        emit(CarRegisterError('يُسمح بالأرقام فقط'));
        await _loadCarNumbers();
        return;
      }

      try {
        final exists = await _sheetsService.numberExists(number);
        if (exists) {
          emit(currentState.copyWith(isAddingNumber: false));
          emit(CarRegisterError('هذه السيارة مسجلة بالفعل'));
          await _loadCarNumbers();
          return;
        }

        final success = await _sheetsService.addNumber(number);
        if (success) {
          await _loadCarNumbersWithSuccess('تم الحفظ بنجاح');
        } else {
          emit(currentState.copyWith(isAddingNumber: false));
          emit(CarRegisterError('حدث خطأ ما، يرجى المحاولة مرة أخرى'));
          await _loadCarNumbers();
        }
      } catch (e) {
        emit(currentState.copyWith(isAddingNumber: false));
        emit(CarRegisterError('حدث خطأ ما، يرجى المحاولة مرة أخرى'));
        await _loadCarNumbers();
      }
    }
  }

  Future<void> deleteCarNumber(String number) async {
    if (state is CarRegisterLoaded) {
      final currentState = state as CarRegisterLoaded;

      // Show deleting loading state
      emit(currentState.copyWith(isDeletingNumber: true));

      // Check connectivity
      if (!_connectivityService.isConnected) {
        emit(currentState.copyWith(isDeletingNumber: false));
        emit(CarRegisterError('مطلوب اتصال بالإنترنت'));
        await _loadCarNumbers();
        return;
      }

      try {
        final success = await _sheetsService.deleteNumber(number);
        if (success) {
          await _loadCarNumbersWithSuccess('تم الحذف بنجاح');
        } else {
          emit(currentState.copyWith(isDeletingNumber: false));
          emit(CarRegisterError('حدث خطأ ما، يرجى المحاولة مرة أخرى'));
          await _loadCarNumbers();
        }
      } catch (e) {
        emit(currentState.copyWith(isDeletingNumber: false));
        emit(CarRegisterError('حدث خطأ ما، يرجى المحاولة مرة أخرى'));
        await _loadCarNumbers();
      }
    }
  }

  Future<void> refreshData() async {
    await _loadCarNumbers();
  }

  Future<void> _loadCarNumbers() async {
    try {
      final numbers = await _sheetsService.getAllNumbers();
      final isConnected = _connectivityService.isConnected;
      emit(
        CarRegisterLoaded(
          carNumbers: numbers,
          isConnected: isConnected,
          isAddingNumber: false,
          isDeletingNumber: false,
        ),
      );
    } catch (e) {
      emit(CarRegisterError('فشل في تحميل البيانات: $e'));
    }
  }

  Future<void> _loadCarNumbersWithSuccess(String successMessage) async {
    try {
      final numbers = await _sheetsService.getAllNumbers();
      final isConnected = _connectivityService.isConnected;
      emit(
        CarRegisterLoaded(
          carNumbers: numbers,
          isConnected: isConnected,
          successMessage: successMessage.contains('حذف')
              ? null
              : successMessage, // Only show success for add, not delete
          isAddingNumber: false,
          isDeletingNumber: false,
        ),
      );

      // Clear success message after 2 seconds for add operations only
      if (!successMessage.contains('حذف')) {
        Future.delayed(const Duration(seconds: 2), () {
          if (state is CarRegisterLoaded) {
            final currentState = state as CarRegisterLoaded;
            emit(currentState.copyWith(successMessage: null));
          }
        });
      }
    } catch (e) {
      emit(CarRegisterError('فشل في تحميل البيانات: $e'));
    }
  }

  @override
  Future<void> close() {
    _connectivityService.dispose();
    return super.close();
  }
}
