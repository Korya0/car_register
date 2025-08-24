import 'package:car_register_app/features/loc_app/data/repositories/firebase_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LockAppCubit extends Cubit<bool> {
  final LockAppRepository _repository;
  final String userId = 'user123';

  LockAppCubit(this._repository) : super(false);

  Future<void> loadBoolean() async {
    try {
      final value = await _repository.getBoolean(userId);
      if (!isClosed) {
        emit(value ?? false);
      }
    } catch (e) {
      if (!isClosed) {
        emit(false);
      }
    }
  }
}
