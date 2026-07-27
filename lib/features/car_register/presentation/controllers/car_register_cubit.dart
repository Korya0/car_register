import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/core/error/failure.dart';
import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';
import 'package:car_register_app/features/car_register/data/repositories/car_number_repository.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarRegisterCubit extends Cubit<CarRegisterState> {
  final CarNumberRepository _repository;

  CarRegisterCubit(this._repository) : super(const CarRegisterInitial());

  List<CarNumberModel> get _currentNumbers => switch (state) {
        CarRegisterLoaded s => s.carNumbers,
        CarRegisterFailure s => s.carNumbers,
        _ => const [],
      };

  AppPageView get _currentPage => switch (state) {
        CarRegisterLoaded s => s.currentPage,
        CarRegisterFailure s => s.currentPage,
        _ => AppPageView.add,
      };

  Future<void> initializeApp() async {
    emit(const CarRegisterLoading());
    final result = await _repository.initialize();
    result.when(
      success: (_) async {
        await _loadCarNumbers();
      },
      failure: (f) {
        emit(CarRegisterFailure(failure: f));
      },
    );
  }

  Future<void> addCarNumber(String number) async {
    final loaded = _assertLoaded();
    if (loaded == null) return;
    emit(loaded.copyWith(isAddingNumber: true));
    
    final newModel = CarNumberModel(number: number);
    final result = await _repository.addNumber(newModel);
    
    result.when(
      success: (added) {
        if (added) {
          emit(loaded.copyWith(
            carNumbers: [...loaded.carNumbers, newModel],
            successMessage: AppStrings.savedSuccessfully,
          ));
        } else {
          emit(CarRegisterFailure(
            failure: const UnknownFailure(AppStrings.numberAlreadyExists),
            carNumbers: loaded.carNumbers,
            currentPage: loaded.currentPage,
          ));
        }
      },
      failure: (f) {
        emit(CarRegisterFailure(
          failure: f,
          carNumbers: loaded.carNumbers,
          currentPage: loaded.currentPage,
        ));
        _loadCarNumbers(forceRefresh: true);
      },
    );
  }

  Future<void> deleteCarNumber(String number) async {
    final loaded = _assertLoaded();
    if (loaded == null) return;
    emit(loaded.copyWith(isDeletingNumber: true));
    final result = await _repository.deleteNumber(number);
    result.when(
      success: (_) {
        emit(loaded.copyWith(
          carNumbers: loaded.carNumbers.where((n) => n.number != number).toList(),
          successMessage: AppStrings.deletedSuccessfully,
        ));
      },
      failure: (f) {
        emit(CarRegisterFailure(
          failure: f,
          carNumbers: loaded.carNumbers,
          currentPage: loaded.currentPage,
        ));
        _loadCarNumbers(forceRefresh: true);
      },
    );
  }

  Future<void> deleteMultiple(List<String> numbers) async {
    final loaded = _assertLoaded();
    if (loaded == null) return;
    emit(loaded.copyWith(isDeletingNumber: true));
    final result = await _repository.deleteNumbers(numbers);
    result.when(
      success: (_) {
        final targetSet = numbers.toSet();
        emit(loaded.copyWith(
          carNumbers: loaded.carNumbers.where((n) => !targetSet.contains(n.number)).toList(),
          successMessage: AppStrings.deletedSuccessfully,
        ));
      },
      failure: (f) {
        emit(CarRegisterFailure(
          failure: f,
          carNumbers: loaded.carNumbers,
          currentPage: loaded.currentPage,
        ));
        _loadCarNumbers(forceRefresh: true);
      },
    );
  }

  Future<void> clearAll() async {
    final loaded = _assertLoaded();
    if (loaded == null) return;
    emit(loaded.copyWith(isDeletingNumber: true));
    final result = await _repository.clearAll();
    result.when(
      success: (_) {
        emit(loaded.copyWith(
          carNumbers: const [],
          successMessage: AppStrings.allDeletedSuccessfully,
        ));
      },
      failure: (f) {
        emit(CarRegisterFailure(
          failure: f,
          carNumbers: loaded.carNumbers,
          currentPage: loaded.currentPage,
        ));
        _loadCarNumbers(forceRefresh: true);
      },
    );
  }

  void setCurrentPage(AppPageView page) {
    final loaded = _assertLoaded();
    if (loaded == null) return;
    emit(loaded.copyWith(currentPage: page));
  }

  void clearSuccessMessage() {
    if (state case CarRegisterLoaded s) {
      emit(s.copyWith(successMessage: null));
    }
  }

  void clearFailure() {
    if (state case CarRegisterFailure s) {
      emit(CarRegisterLoaded(
        carNumbers: s.carNumbers,
        currentPage: s.currentPage,
      ));
    }
  }

  CarRegisterLoaded? _assertLoaded() {
    if (state case CarRegisterLoaded s) return s;
    return null;
  }

  Future<void> _loadCarNumbers({bool forceRefresh = false}) async {
    final result = await _repository.getAllNumbers(forceRefresh: forceRefresh);
    result.when(
      success: (numbers) {
        emit(CarRegisterLoaded(
          carNumbers: numbers,
          currentPage: _currentPage,
        ));
      },
      failure: (f) {
        emit(CarRegisterFailure(
          failure: f,
          carNumbers: _currentNumbers,
          currentPage: _currentPage,
        ));
      },
    );
  }
}
