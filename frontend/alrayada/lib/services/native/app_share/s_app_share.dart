import '/services/native/app_share/app_share.dart';
import 'app_share_impl.dart';
// import './package_share_plus_app_share.dart';

class AppShareService implements AppShare {
  AppShareService._();
  static final instance = AppShareService._();

  final AppShare _service = AppShareImpl();
  // final AppShare _service = PackageSharePlusAppShare();

  @override
  Future<bool> shareText(String text, String? subject) =>
      _service.shareText(text, subject);
}
