import 'package:url_launcher/url_launcher.dart' show LaunchMode;
import 'package:url_launcher/url_launcher_string.dart' as launcher;

import 'url_launcher.dart';

class PackageUrlLauncher extends UrlLauncher {
  @override
  Future<void> launchStringUrl(String url) async {
    // if (!(await launcher.canLaunchUrlString(url))) {
    //   return;
    // }
    await launcher.launchUrlString(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Future<bool> canLaunchStringUrl(String url) =>
      launcher.canLaunchUrlString(url);
}
