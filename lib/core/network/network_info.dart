import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  late final Connectivity connectivity;

  NetworkInfo({required this.connectivity});

  Future<bool> get isConnected async {
    ConnectivityResult connectivityResult =
        await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      return Future.value(true);
    } else if (connectivityResult == ConnectivityResult.none) {
      return Future.value(false);
    }

    return Future.value(false);
  }
}
