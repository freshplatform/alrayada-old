import 'package:flutter/widgets.dart' show BuildContext;

import '../l10n/app_localizations.dart';

extension BuildContextExt on BuildContext {
  AppLocalizations get loc {
    return AppLocalizations.of(this) ?? (throw 'The localizations is required');
  }
}
