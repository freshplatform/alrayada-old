import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:lottie/lottie.dart';

import '../../core/theme_data.dart';
import '../../gen/assets.gen.dart';
import '../../utils/extensions/build_context.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  static final _assets = Assets.lottie.pageNotFound.values;

  @override
  Widget build(BuildContext context) {
    final translations = context.loc;

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(translations.page_not_found),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Lottie.asset(
                    _assets[math.Random().nextInt(_assets.length)].path,
                  ),
                  Text(
                    translations.this_page_cant_be_found_msg,
                    textAlign: TextAlign.center,
                    style: MyAppTheme.getNormalTextStyle(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
