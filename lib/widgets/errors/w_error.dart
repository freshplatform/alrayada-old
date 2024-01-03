import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:lottie/lottie.dart';

import '../../gen/assets.gen.dart';
import '/core/locales.dart';

class _LottieErrorWidget extends StatelessWidget {
  const _LottieErrorWidget();

  @override
  Widget build(BuildContext context) {
    final asset = Assets.lottie.error1.path;
    return LayoutBuilder(
      builder: (context, constranints) {
        final isLandscape =
            MediaQuery.orientationOf(context) == Orientation.landscape;
        if (isLandscape) {
          return Lottie.asset(
            asset,
            width: constranints.maxWidth * 0.6,
            height: 180,
          );
        }
        return Lottie.asset(asset);
      },
    );
  }
}

class ErrorWithTryAgain extends StatelessWidget {
  const ErrorWithTryAgain({
    required this.onTryAgain, super.key,
  });

  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    final items = [
      const _LottieErrorWidget(),
      PlatformElevatedButton(
        onPressed: onTryAgain,
        child: Text(translations.try_again),
      )
    ];
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: items,
        ),
      ),
    );
  }
}

class ErrorWithoutTryAgain extends StatelessWidget {
  const ErrorWithoutTryAgain({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Lottie.asset(Assets.lottie.error1.path),
      ),
    );
  }
}
