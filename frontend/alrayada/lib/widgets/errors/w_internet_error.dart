import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:lottie/lottie.dart';

import '../../core/locales.dart';
import '../../gen/assets.gen.dart';

final error = [
  Assets.lottie.noInternet.noInternet1.path,
  Assets.lottie.noInternet.noInternet2.path,
  Assets.lottie.noInternet.noInternet3.path,
];

class InternetErrorWithTryAgain extends StatelessWidget {
  const InternetErrorWithTryAgain({
    Key? key,
    required this.onTryAgain,
  }) : super(key: key);

  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    final materialTheme = Theme.of(context);
    final cupertinoTheme = CupertinoTheme.of(context);
    final randomAsset = error[Random().nextInt(error.length)];
    final items = [
      Lottie.asset(randomAsset),
      Text(
        translations.please_check_your_internet_connection_msg,
        style: isCupertino(context)
            ? cupertinoTheme.textTheme.textStyle.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              )
            : materialTheme.textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 8),
      PlatformElevatedButton(
        onPressed: onTryAgain,
        child: Text(translations.try_again),
      )
    ];
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: items,
      ),
    );
  }
}

class InternetErrorWithoutTryAgainDialog extends StatelessWidget {
  const InternetErrorWithoutTryAgainDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    final materialTheme = Theme.of(context);
    final cupertinoTheme = CupertinoTheme.of(context);
    final randomAsset = error[Random().nextInt(error.length)];
    final items = [
      Lottie.asset(randomAsset),
      Text(
        translations.please_check_your_internet_connection_msg,
        style: isCupertino(context)
            ? cupertinoTheme.textTheme.textStyle.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              )
            : materialTheme.textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
    ];
    return PlatformAlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: items,
      ),
      actions: [
        PlatformDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(translations.close),
        )
      ],
    );
  }
}
