import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_alrayada/server/server.dart';

import '/core/locales.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../services/native/url_launcher/s_url_launcher.dart';
import '../../../../widgets/adaptive/w_icon.dart';

class SocialMediaLinksDialog extends StatelessWidget {
  const SocialMediaLinksDialog({Key? key}) : super(key: key);

  Widget _buildIcon({
    required String imagePath,
    required VoidCallback onTap,
    required String label,
    double width = 80,
  }) =>
      PlatformIconButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        icon: SvgPicture.asset(
          imagePath,
          width: width,
          semanticsLabel: label,
          height: 80,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(translations.social_media),
      content: SizedBox(
        height: 220,
        width: MediaQuery.sizeOf(context).width * .7,
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          children: [
            _buildIcon(
              imagePath: Assets.svg.icFacebook.path,
              onTap: () => UrlLauncherService.instance
                  .openFacebookPageById(SocialMedia.facebookPageId),
              label: 'Facebook',
            ),
            _buildIcon(
              imagePath: Assets.svg.icInstagram.path,
              onTap: () => UrlLauncherService.instance
                  .openFacebookPageById(SocialMedia.facebookPageId),
              label: 'Instagram',
            ),
            _buildIcon(
              imagePath: Assets.svg.icWhatsapp.path,
              onTap: () => UrlLauncherService.instance.openWhatsappChat(
                SocialMedia.whatsappPhoneNumber,
              ),
              label: 'Whatsapp',
            ),
            PlatformIconButton(
              onPressed: () => UrlLauncherService.instance
                  .launchStringUrl(SocialMedia.phoneNumber),
              padding: EdgeInsets.zero,
              icon: Icon(
                PlatformAdaptiveIcon.getPlatformIconData(
                  iconData: Icons.phone,
                  cupertinoIconData: CupertinoIcons.phone,
                ),
                semanticLabel: 'Phone',
                size: 80,
              ),
            )
          ],
        ),
      ),
      actions: [
        PlatformDialogAction(
          child: Text(translations.cancel),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
