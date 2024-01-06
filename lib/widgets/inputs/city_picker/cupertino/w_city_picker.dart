import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../../cubits/settings/settings_cubit.dart';
import '../../../../data/user/models/m_user.dart';
import '../../../../utils/extensions/build_context.dart';
import '../city_picker_utils.dart';

class CupertinoCityPickerActionSheet extends StatefulWidget {
  const CupertinoCityPickerActionSheet({
    required this.initialCity,
    required this.onSelectedItemChanged,
    super.key,
  });
  final IraqGovernorate initialCity;
  final Function(IraqGovernorate selected) onSelectedItemChanged;

  @override
  State<CupertinoCityPickerActionSheet> createState() =>
      _CupertinoCityPickerActionSheetState();
}

class _CupertinoCityPickerActionSheetState
    extends State<CupertinoCityPickerActionSheet> {
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
      final isAnimationsEnabled =
          context.read<SettingsCubit>().state.isAnimationsEnabled;
      if (isAnimationsEnabled) {
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
    final translations = context.loc;
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
