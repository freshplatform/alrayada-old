import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:shared_alrayada/data/user/m_user.dart';

import '../../../extensions/build_context.dart';
import '/data/location/s_location.dart';
import '/widgets/inputs/city_picker/cupertino/w_city_picker.dart';
import 'city_picker_utils.dart';

class CityDropDownFormField extends StatefulWidget {
  const CityDropDownFormField({
    required this.onSaved,
    super.key,
    this.initialCity = IraqGovernorate.baghdad,
  });

  final FormFieldSetter<IraqGovernorate> onSaved;
  final IraqGovernorate initialCity;

  @override
  State<CityDropDownFormField> createState() => _CityDropDownFormFieldState();
}

class _CityDropDownFormFieldState extends State<CityDropDownFormField> {
  var _isLoading = false;
  var _selectedCity = IraqGovernorate.baghdad;

  Future<void> _cupertinoShowActionSheet() async {
    final response = await showPlatformModalSheet<IraqGovernorate?>(
      context: context,
      builder: (context) => CupertinoCityPickerActionSheet(
        initialCity: _selectedCity,
        onSelectedItemChanged: (selected) {
          setState(() => _selectedCity = selected);
        },
      ),
    );
    if (response == null) {
      return;
    }
    widget.onSaved(response);
  }

  Future<void> _setDefaultLocation() async {
    setState(() => _isLoading = true);
    final city = await CityPickerUtils.getCity();
    setState(() {
      _selectedCity = city;
      _isLoading = false;
    });
  }

  Future<void> _setDefaultCachedLocation() async {
    final geoLocation = await LocationService.getCachedIpLocation();
    if (geoLocation == null) return;
    if (!IraqGovernorate.values.map((e) => e.name).contains(geoLocation.city)) {
      return;
    }
    setState(() {
      _selectedCity = IraqGovernorate.values.firstWhere((element) =>
          geoLocation.city.toLowerCase() == element.name.toLowerCase());
    });
  }

  @override
  void initState() {
    super.initState();
    _initState();
  }

  Future<void> _initState() async {
    _selectedCity = widget.initialCity;
    await _setDefaultCachedLocation();
    widget.onSaved(_selectedCity); // this is line required on ios
  }

  @override
  Widget build(BuildContext context) {
    final translations = context.loc;
    return Semantics(
      label: translations.city,
      child: PlatformWidget(
        cupertino: (context, platform) => PlatformTextButton(
          onPressed: _cupertinoShowActionSheet,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.location),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  translations.selected_city(
                    CityPickerUtils.getTranslatedCityName(
                      context,
                      _selectedCity,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        material: (context, platform) => DropdownButtonFormField(
          value: _selectedCity,
          items: IraqGovernorate.values
              .map((e) => DropdownMenuItem(
                    value: e,
                    alignment: Alignment.center,
                    child: Text(
                      CityPickerUtils.getTranslatedCityName(context, e),
                      textScaleFactor: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          onChanged: (value) =>
              setState(() => _selectedCity = value ?? _selectedCity),
          decoration: InputDecoration(
            labelText: translations.city,
            suffixIcon: const Icon(Icons.location_city),
            icon: IconButton(
              onPressed: _isLoading ? null : _setDefaultLocation,
              icon: const Icon(Icons.gps_fixed),
            ),
          ),
          onSaved: (value) => widget.onSaved(value),
        ),
      ),
    );
  }
}
