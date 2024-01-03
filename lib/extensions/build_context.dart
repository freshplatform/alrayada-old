import 'package:flutter/widgets.dart';

import '../core/locales.dart';

extension BuildContextExt on BuildContext {
  AppLocalizations get loc {
    return AppLocalizations.of(this) ?? (throw 'The localizations is required');
  }
}
