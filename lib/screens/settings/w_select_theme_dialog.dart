import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/locales.dart';
import '/providers/p_theme_mode.dart';

class SelectThemeDialog extends StatelessWidget {
  const SelectThemeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    return PlatformAlertDialog(
      title: Text(translations.theme_mode),
      content: const SelectThemeDialogContent(),
      actions: [
        PlatformDialogAction(
          child: Text(translations.cancel),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}

class SelectThemeDialogContent extends ConsumerWidget {
  const SelectThemeDialogContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: This is need to be tested!
    final themeMode = ref.read(ThemeModeNotifier
        .themeModeProvider); // not really needed to watched since the whole app will rebuilt
    final themeModeProvider =
        ref.read(ThemeModeNotifier.themeModeProvider.notifier);
    final translations = AppLocalizations.of(context)!;
    final children = {
      ThemeMode.dark: Text(translations.dark),
      ThemeMode.light: Text(translations.light),
      ThemeMode.system: Text(translations.system),
    };
    if (isCupertino(context)) {
      return CupertinoSlidingSegmentedControl<ThemeMode>(
        groupValue: themeMode,
        onValueChanged: (value) => themeModeProvider.setThemeMode(value!),
        children: children,
      );
    }
    return ToggleButtons(
      isSelected: children.entries.map((e) => e.key == themeMode).toList(),
      onPressed: (index) {
        switch (index) {
          case 0:
            themeModeProvider.setThemeMode(ThemeMode.dark);
            break;
          case 1:
            themeModeProvider.setThemeMode(ThemeMode.light);
            break;
          case 2:
            themeModeProvider.setThemeMode(ThemeMode.system);
            break;
        }
      },
      borderRadius: BorderRadius.circular(30),
      // selectedBorderColor: Colors.blue,
      // selectedColor: Colors.blue,
      // color: Colors.grey[400],
      children: children.values
          .map((e) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: e,
              ))
          .toList(),
    );
  }
}
