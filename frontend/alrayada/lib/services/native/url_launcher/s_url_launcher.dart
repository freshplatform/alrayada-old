import 'package:flutter/services.dart' show PlatformException;

import 'package_url_launcher.dart';
import 'url_launcher.dart';

class UrlLauncherService implements UrlLauncher, SocialMediaAppLinks {
  UrlLauncherService._();
  static final instance = UrlLauncherService._();

  final UrlLauncher _urlLauncher = PackageUrlLauncher();

  @override
  Future<void> launchStringUrl(String url) => _urlLauncher.launchStringUrl(url);

  @override
  Future<bool> canLaunchStringUrl(String url) =>
      _urlLauncher.canLaunchStringUrl(url);

  @override
  Future<void> openFacebookPageById(String pageId) async {
    final urlWeb = 'https://www.facebook.com/$pageId';
    final urlScheme = 'fb://facewebmodal/f?href=$urlWeb';

    try {
      await launchStringUrl(urlScheme);
    } on PlatformException {
      await launchStringUrl(urlWeb);
    }
  }

  @override
  Future<void> openWhatsappChat(String phoneNumber) async {
    final urlScheme = 'whatsapp://send?phone=$phoneNumber';
    final urlWeb = 'https://wa.me/$phoneNumber';

    try {
      await launchStringUrl(urlScheme);
    } on PlatformException {
      await launchStringUrl(urlWeb);
    }
  }
}

abstract class SocialMediaAppLinks {
  Future<void> openFacebookPageById(String pageId);
  Future<void> openWhatsappChat(String phoneNumber);
}
