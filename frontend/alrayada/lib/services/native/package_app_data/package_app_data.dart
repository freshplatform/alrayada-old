import 'package:flutter/foundation.dart' show immutable;

@immutable
class PackageAppDataInfo {
  final int buildNumber;
  final String buildName;
  final String packageName;

  const PackageAppDataInfo({
    required this.buildNumber,
    required this.buildName,
    required this.packageName,
  });
}

abstract class PackageAppData {
  Future<PackageAppDataInfo> loadPackageInfo();
}
