import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<ConnectivityResult> connectivityStatus(ConnectivityStatusRef ref) {
  return Connectivity().onConnectivityChanged;
}

@riverpod
bool isOnline(IsOnlineRef ref) {
  final connectivityResult = ref.watch(connectivityStatusProvider);
  return connectivityResult.when(
    data: (result) => result != ConnectivityResult.none,
    loading: () => true, // Assume online while loading
    error: (_, __) => false, // Assume offline on error
  );
}