import 'package:alrayada/core/locales.dart';
import 'package:alrayada/services/native/url_launcher/s_url_launcher.dart';
import 'package:alrayada/widgets/adaptive/w_card.dart';
import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:linkify_plus/linkify_plus.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  static const routeName = '/privacyPolicy';

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    return PlatformScaffold(
      appBar: PlatformAppBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: AdaptiveCard(
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Linkify(
                  text: translations.privacy_policy_text,
                  onOpen: (link) =>
                      UrlLauncherService.instance.launchStringUrl(link.url),
                  options: const LinkifyOptions(humanize: false),
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
