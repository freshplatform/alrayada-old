import 'package_app_data.dart';
import 'package_app_data_impl.dart';

class PackageAppDataService implements PackageAppData {
  PackageAppDataService._();
  static final instance = PackageAppDataService._();
  // final PackageAppData _packageAppDataFetcher = PackageInfoPlusPackageAppData();
  final PackageAppData _packageAppDataFetcher = PackageAppDataImpl();

  @override
  Future<PackageAppDataInfo> loadPackageInfo() =>
      _packageAppDataFetcher.loadPackageInfo();
}
