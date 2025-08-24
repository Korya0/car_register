import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  void initialize() {
    _checkConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
      _isConnected = result != ConnectivityResult.none;
    });
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _isConnected = result != ConnectivityResult.none;
    } catch (e) {
      _isConnected = false;
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
