import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:tipl_app/core/providers/recall_provider.dart';


class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final ValueNotifier<bool> isConnected = ValueNotifier(true);
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  List<VoidCallback> _onReconnect = [];

  void addOnReconnectListener(VoidCallback callback){
    _onReconnect.add(callback);
  }

  void removeReconnectListener(VoidCallback callback){
    _onReconnect.remove(callback);
  }

  void initialize(GlobalKey<ScaffoldMessengerState> messengerKey) {
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      final online = result.contains(ConnectivityResult.none);
      isConnected.value = online;
      if (online) {
        messengerKey.currentState?.showSnackBar(
          SnackBar(
            content: const Text("No internet connection"),
            backgroundColor: Colors.red,
            dismissDirection: DismissDirection.none,
            duration: const Duration(days: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        messengerKey.currentState?.clearSnackBars();
        for(var callback in _onReconnect){
          callback.call();
        }
      }
    });
  }

  void dispose() => _subscription.cancel();

}