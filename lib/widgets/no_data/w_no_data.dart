import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:lottie/lottie.dart';

import '../../extensions/build_context.dart';
import '../../gen/assets.gen.dart';
import '/core/theme_data.dart';

class _LottieNoDataWidget extends StatelessWidget {
  const _LottieNoDataWidget();

  @override
  Widget build(BuildContext context) {
    final asset = Assets.lottie.noData1.path;
    return LayoutBuilder(builder: (context, constranints) {
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
    });
  }
}

class NoDataWithTryAgain extends StatelessWidget {
  const NoDataWithTryAgain({
    required this.onRefresh,
    super.key,
  });
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final translations = context.loc;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const _LottieNoDataWidget(),
          PlatformElevatedButton(
            onPressed: onRefresh,
            child: Text(translations.refresh),
          )
        ],
      ),
    );
  }
}

class NoDataWithoutTryAgain extends StatelessWidget {
  const NoDataWithoutTryAgain({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final translations = context.loc;
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _LottieNoDataWidget(),
            Text(
              translations.no_data,
              style: MyAppTheme.getNormalTextStyle(context),
            )
          ],
        ),
      ),
    );
  }
}
