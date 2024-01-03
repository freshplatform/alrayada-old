// import '/services/native/connectivity_checker/connectivity_checker.dart';
// import '/services/native/connectivity_checker/package_connectivity_plus.dart';

// export './connectivity_checker.dart';
export 'package:shared_alrayada/services/native/connectivity_checker/s_connectivity_checker.dart';

// class ConnectivityCheckerService implements ConnectivityChecker {
//   ConnectivityCheckerService._();
//   static final instance = ConnectivityCheckerService._();

//   final ConnectivityChecker _connectivityChecker =
//       PackageConnectivityPlusChecker();
//   @override
//   Future<ConnectivityCheckerResult> checkConnectivity() =>
//       _connectivityChecker.checkConnectivity();

//   @override
//   Future<bool> hasConnection() async =>
//       await checkConnectivity() != ConnectivityCheckerResult.none;
// }
