import 'package:flutter/foundation.dart' show immutable;

@immutable
class PackageAppDataInfo {

  const PackageAppDataInfo({
    required this.buildNumber,
    required this.buildName,
    required this.packageName,
  });
  final int buildNumber;
  final String buildName;
  final String packageName;
}

abstract class PackageAppData {
  Future<PackageAppDataInfo> loadPackageInfo();
}
