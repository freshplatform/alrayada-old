// import 'package:flutter/services.dart' show PlatformException;
// import 'package:share_plus/share_plus.dart';
//
// import '/services/native/app_share/app_share.dart';
//
// class PackageSharePlusAppShare extends AppShare {
//   @override
//   Future<bool> shareText(String text, String? subject) async {
//     try {
//       print('Implementation 1');
//       await Share.share(text, subject: subject);
//       return true;
//     } on PlatformException {
//       return false;
//     }
//   }
// }
