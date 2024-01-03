// import 'package:flutter/services.dart' show PlatformException;
// import 'package:package_info_plus/package_info_plus.dart';
//
// import 'package_app_data.dart';
//
// class PackageInfoPlusPackageAppData extends PackageAppData {
//   @override
//   Future<PackageAppDataInfo> loadPackageInfo() async {
//     try {
//       final packageInfo = await PackageInfo.fromPlatform();
//
//       // String appName = packageInfo.appName;
//       String packageName = packageInfo.packageName;
//       String version = packageInfo.version;
//       String buildNumber = packageInfo.buildNumber;
//       return PackageAppDataInfo(
//         buildNumber: int.parse(buildNumber),
//         buildName: version,
//         packageName: packageName,
//       );
//     } on PlatformException {
//       rethrow;
//     }
//   }
// }
