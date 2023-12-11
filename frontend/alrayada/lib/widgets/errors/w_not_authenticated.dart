import '/screens/auth/s_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:lottie/lottie.dart';

import '../../core/locales.dart';
import '../../gen/assets.gen.dart';

class NotAuthenticatedError extends StatelessWidget {
  const NotAuthenticatedError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            Assets.lottie.authenticationSuccess.path,
          ),
          const SizedBox(height: 20),
          PlatformElevatedButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AuthScreen.routeName),
            child: Text(translations.sign_in),
          )
        ],
      ),
    );
  }
}
