import '../datasources/firebase_datasource.dart';

class LockAppRepository {
  final LockAppDataSource _dataSource;

  LockAppRepository(this._dataSource);
  Future<bool?> getBoolean(String userId) async {
    return await _dataSource.getBoolean(userId);
  }
}
