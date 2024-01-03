import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/user/m_user.dart';

import '../city_picker_utils.dart';
import '/core/locales.dart';
import '/providers/p_settings.dart';

class CupertinoCityPickerActionSheet extends ConsumerStatefulWidget {
  const CupertinoCityPickerActionSheet({
    required this.initialCity, required this.onSelectedItemChanged, super.key,
  });
  final IraqGovernorate initialCity;
  final Function(IraqGovernorate selected) onSelectedItemChanged;

  @override
  ConsumerState<CupertinoCityPickerActionSheet> createState() =>
      _CupertinoCityPickerActionSheetState();
}

class _CupertinoCityPickerActionSheetState
    extends ConsumerState<CupertinoCityPickerActionSheet> {
  var _isLoading = false;
  var _selectedCity = IraqGovernorate.baghdad;

  Future<void> _setDefaultLocation() async {
    setState(() => _isLoading = true);
    final city = await CityPickerUtils.getCity();
    setState(() {
      _isLoading = false;
      _selectedCity = city;
    });
  }

  Future<void> _animateToSelectedCity() async {
    try {
      final index = IraqGovernorate.values
          .indexWhere((element) => element == _selectedCity);
      final settingsProvider = ref.read(SettingsNotifier.settingsProvider);
      if (settingsProvider.isAnimationsEnabled) {
        await scrollController.animateToItem(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        );
        return;
      }
      scrollController.jumpToItem(index);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  final FixedExtentScrollController scrollController =
      FixedExtentScrollController();
  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    return CupertinoActionSheet(
      actions: [
        SizedBox(
          height: 200,
          child: CupertinoPicker(
            itemExtent: 32,
            scrollController: scrollController,
            onSelectedItemChanged: (index) =>
                widget.onSelectedItemChanged(IraqGovernorate.values[index]),
            children: IraqGovernorate.values
                .map((e) => Text(
                      CityPickerUtils.getTranslatedCityName(context, e),
                    ))
                .toList(),
          ),
        )
      ],
      message: PlatformIconButton(
        icon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.location_solid),
            Text(translations.auto_detect),
          ],
        ),
        onPressed: _isLoading
            ? null
            : () async {
                await _setDefaultLocation();
                _animateToSelectedCity();
              },
      ),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context).pop(_selectedCity),
        child: Text(translations.close),
      ),
    );
  }
}
