import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StreamProvider<bool>((ref) {
  final connectivity = Connectivity();
  return connectivity.onConnectivityChanged.map((result) {
    final values = result is List<ConnectivityResult>
        ? result
        : <ConnectivityResult>[result as ConnectivityResult];
    return values.any((value) => value != ConnectivityResult.none);
  });
});

final networkInfoProvider = Provider<bool>((ref) {
  final state = ref.watch(connectivityProvider);
  return state.maybeWhen(data: (online) => online, orElse: () => true);
});
