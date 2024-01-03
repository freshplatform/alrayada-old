import 'package:flutter/widgets.dart';
import 'package:shared_alrayada/data/user/m_user.dart';

import '../../../core/locales.dart';
import '../../../data/location/s_location.dart';

class CityPickerUtils {
  const CityPickerUtils._();

  static Future<IraqGovernorate> getCity() async {
    final geoLocation = await LocationService.getIpLocation();
    if (geoLocation == null) {
      return IraqGovernorate.baghdad;
    }
    if (IraqGovernorate.values
        .map((e) => e.name.toLowerCase())
        .contains(geoLocation.city.toLowerCase())) {
      return IraqGovernorate.values.firstWhere((element) =>
          geoLocation.city.toLowerCase() == element.name.toLowerCase());
    }
    return IraqGovernorate.baghdad;
  }

  static String getTranslatedCityName(
      BuildContext context, IraqGovernorate city) {
    final translations = AppLocalizations.of(context)!;
    switch (city) {
      case IraqGovernorate.baghdad:
        return translations.baghdad;
      case IraqGovernorate.basra:
        return translations.basra;
      case IraqGovernorate.maysan:
        return translations.maysan;
      case IraqGovernorate.dhiQar:
        return translations.dhiQar;
      case IraqGovernorate.diyala:
        return translations.diyala;
      case IraqGovernorate.karbala:
        return translations.karbala;
      case IraqGovernorate.kirkuk:
        return translations.kirkuk;
      case IraqGovernorate.najaf:
        return translations.najaf;
      case IraqGovernorate.nineveh:
        return translations.nineveh;
      case IraqGovernorate.wasit:
        return translations.wasit;
      case IraqGovernorate.anbar:
        return translations.anbar;
      case IraqGovernorate.salahAlDin:
        return translations.salahAlDin;
      case IraqGovernorate.babil:
        return translations.babil;
      case IraqGovernorate.babylon:
        return translations.babylon;
      case IraqGovernorate.alMuthanna:
        return translations.alMuthanna;
      case IraqGovernorate.alQadisiyyah:
        return translations.alQadisiyyah;
      case IraqGovernorate.thiQar:
        return translations.thiQar;
    }
  }
}
