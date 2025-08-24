import 'package:car_register_app/core/utils/connectivity_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/services/google_sheets_service.dart';

// Events
abstract class CarRegisterEvent extends Equatable {
  const CarRegisterEvent();

  @override
  List<Object?> get props => [];
}

class InitializeApp extends CarRegisterEvent {}

class AddCarNumber extends CarRegisterEvent {
  final String number;

  const AddCarNumber(this.number);

  @override
  List<Object?> get props => [number];
}

class DeleteCarNumber extends CarRegisterEvent {
  final String number;

  const DeleteCarNumber(this.number);

  @override
  List<Object?> get props => [number];
}

class RefreshData extends CarRegisterEvent {}

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

  const CarRegisterLoaded({
    required this.carNumbers,
    required this.isConnected,
    this.successMessage,
  });

  @override
  List<Object?> get props => [carNumbers, isConnected, successMessage];

  CarRegisterLoaded copyWith({
    List<String>? carNumbers,
    bool? isConnected,
    String? successMessage,
  }) {
    return CarRegisterLoaded(
      carNumbers: carNumbers ?? this.carNumbers,
      isConnected: isConnected ?? this.isConnected,
      successMessage: successMessage,
    );
  }
}

class CarRegisterError extends CarRegisterState {
  final String message;

  const CarRegisterError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
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
      // Initialize connectivity service
      _connectivityService.initialize();

      // Initialize Google Sheets
      final sheetsInitialized = await _sheetsService.initialize();
      if (!sheetsInitialized) {
        emit(const CarRegisterError('فشل في تهيئة Google Sheets'));
        return;
      }

      // Load initial data
      await _loadCarNumbers();
    } catch (e) {
      emit(CarRegisterError('حدث خطأ أثناء التهيئة: $e'));
    }
  }

  Future<void> addCarNumber(String number) async {
    if (state is CarRegisterLoaded) {
      final currentState = state as CarRegisterLoaded;

      // Check connectivity
      if (!_connectivityService.isConnected) {
        emit(CarRegisterError('مطلوب اتصال بالإنترنت'));
        await _loadCarNumbers(); // Restore previous state
        return;
      }

      // Validate input (digits only)
      if (!RegExp(r'^\d+$').hasMatch(number)) {
        emit(CarRegisterError('يُسمح بالأرقام فقط'));
        await _loadCarNumbers(); // Restore previous state
        return;
      }

      try {
        // Check if number already exists
        final exists = await _sheetsService.numberExists(number);
        if (exists) {
          emit(CarRegisterError('هذه السيارة مسجلة بالفعل'));
          await _loadCarNumbers(); // Restore previous state
          return;
        }

        // Add number to sheets
        final success = await _sheetsService.addNumber(number);
        if (success) {
          await _loadCarNumbersWithSuccess('تم الحفظ بنجاح');
        } else {
          emit(CarRegisterError('حدث خطأ ما، يرجى المحاولة مرة أخرى'));
          await _loadCarNumbers(); // Restore previous state
        }
      } catch (e) {
        emit(CarRegisterError('حدث خطأ ما، يرجى المحاولة مرة أخرى'));
        await _loadCarNumbers(); // Restore previous state
      }
    }
  }

  Future<void> deleteCarNumber(String number) async {
    if (state is CarRegisterLoaded) {
      final currentState = state as CarRegisterLoaded;

      // Check connectivity
      if (!_connectivityService.isConnected) {
        emit(CarRegisterError('مطلوب اتصال بالإنترنت'));
        await _loadCarNumbers(); // Restore previous state
        return;
      }

      try {
        final success = await _sheetsService.deleteNumber(number);
        if (success) {
          await _loadCarNumbersWithSuccess('تم الحذف بنجاح');
        } else {
          emit(CarRegisterError('حدث خطأ ما، يرجى المحاولة مرة أخرى'));
          await _loadCarNumbers(); // Restore previous state
        }
      } catch (e) {
        emit(CarRegisterError('حدث خطأ ما، يرجى المحاولة مرة أخرى'));
        await _loadCarNumbers(); // Restore previous state
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
      emit(CarRegisterLoaded(carNumbers: numbers, isConnected: isConnected));
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
          successMessage: successMessage,
        ),
      );

      // Clear success message after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (state is CarRegisterLoaded) {
          final currentState = state as CarRegisterLoaded;
          emit(currentState.copyWith(successMessage: null));
        }
      });
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
