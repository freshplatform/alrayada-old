import 'package:connectivity_plus/connectivity_plus.dart' show Connectivity;
import '/services/native/connectivity_checker/connectivity_checker.dart';

class PackageConnectivityPlusChecker extends ConnectivityChecker {
  final connectivityChecker = Connectivity();
  @override
  Future<ConnectivityCheckerResult> checkConnectivity() async {
    final connectivity = await connectivityChecker.checkConnectivity();
    for (final element in ConnectivityCheckerResult.values) {
      if (element.name == connectivity.name) {
        return element;
      }
    }
    return ConnectivityCheckerResult.none;
  }

  @override
  Future<bool> hasConnection() async =>
      await checkConnectivity() != ConnectivityCheckerResult.none;
}
