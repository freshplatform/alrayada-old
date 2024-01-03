import 'package:flutter/services.dart' show MethodChannel, PlatformException;

import '../../../utils/constants/constants.dart';
import 'package_app_data.dart';

class PackageAppDataImpl extends PackageAppData {
  final _appChannel = const MethodChannel('${Constants.packageName}/app');

  @override
  Future<PackageAppDataInfo> loadPackageInfo() async {
    try {
      final result = await _appChannel.invokeMethod('getPackageInfo')
          as Map<Object?, Object?>;
      return PackageAppDataInfo(
        buildNumber: result['buildNumber'] as int,
        buildName: result['buildName'] as String? ?? '',
        packageName: result['packageName'] as String? ?? '',
      );
    } on PlatformException {
      rethrow;
    }
  }
}
