import 'package:flutter/foundation.dart' show kDebugMode, immutable;

@immutable
class ServerConfigurations {
  const ServerConfigurations._privateConstructor();
  static const devPort = 8080;
  static const developmentBaseUrl = 'http://192.168.0.151:$devPort/';
  // static const developmentBaseUrl = 'http://192.168.180.203:8080/';
  // Platform.isIOS ? 'http://localhost:$port/' : 'http://10.0.2.2:$port/';
  static const productionBaseUrl = 'https://alrayada.net/';
  static const serverApiKey =
      '_2FmEXrM1qd5Jy5b8GQA5JpaB5AGgUf2MclSi_kn0kegTdh2_J8m6fJPnlLoi9rA0vAgsjyJjddUzNH7CBkEog';

  static const appleAuthServiceClientId = 'com.ahmedhnewa.alrayada.service';
  static const googleAuthServerClientId =
      '58115250798-d7u24hv9509pv8hgk1rq66n7ehe8l90b.apps.googleusercontent.com';
  static const oneSignalAppId = '760d632c-e511-440b-aa7a-f92d4daa7312';

  static const forceUseProduction = false;

  // static bool get isRealDevice =>
  //     !Platform.version.toString().contains('emulator');

  static const appName = 'Alrayada';
  static const developerUrl = 'https://ahmedhnewa.com';
  static const privacyPolicy = 'https://alrayada.net/privacy-policy';

  static const apiRoute = 'api/';

  static String getProductionBaseUrl() {
    return '$productionBaseUrl$apiRoute';
  }

  static String getBaseUrl() {
    if (kDebugMode && !forceUseProduction) {
      // if (!isRealDevice) {
      //   if (Platform.isAndroid) {
      //     return 'http://10.0.2.2:$devPort/';
      //   }
      //   return 'http://localhost:$devPort/';
      // }
      return '$developmentBaseUrl$apiRoute';
    }
    return getProductionBaseUrl();
  }

  static String getBaseWsUrl() {
    final baseHttpUri = Uri.parse(getBaseUrl());
    if (kDebugMode && !forceUseProduction) {
      return baseHttpUri.replace(scheme: 'ws').toString();
    }
    return baseHttpUri.replace(scheme: 'wss').toString();
  }

  static String getImageUrl(String imageUrl) {
    final uri = Uri.parse(imageUrl);
    if (kDebugMode && uri.host == 'localhost') {
      final devUri = Uri.parse(developmentBaseUrl);
      return uri.replace(host: devUri.host).toString();
    }
    return imageUrl;
  }
}

@immutable
class SocialMedia {
  const SocialMedia._privateConstructor();

  static const facebookPageId = 'alread2022';
  static const whatsappPhoneNumber = '+9647704067116';
  static const phoneNumber = 'tel:07741795164';
}
