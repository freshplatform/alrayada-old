import 'package:alrayada/utils/constants/constants.dart';
import 'package:flutter/services.dart' show MethodChannel, PlatformException;

import 'app_share.dart';

class AppShareImpl extends AppShare {
  final _appChannel = const MethodChannel('${Constants.packageName}/app');

  @override
  Future<bool> shareText(String text, String? subject) async {
    try {
      final result = _appChannel.invokeMethod(
        'shareText',
        {'text': text, 'subject': subject},
      ) as bool;
      return result;
    } on PlatformException {
      return false;
    }
  }
}
