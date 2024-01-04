import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/server/server.dart';

import '../../data/favorite/s_favorite.dart';
import '../../extensions/build_context.dart';
import '../../services/native/package_app_data/package_app_data.dart';
import '../../services/native/url_launcher/s_url_launcher.dart';
import '../../widgets/adaptive/w_icon.dart';
import '/providers/p_settings.dart';
import '/screens/settings/w_select_theme_dialog.dart';
import '/services/native/package_app_data/s_package_app_data.dart';
import 'w_option_checkbox.dart';
import 'w_settings_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsProvider =
        ref.read(SettingsNotifier.settingsProvider.notifier);
    final translations = context.loc;
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(translations.settings),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: settingsProvider.loadSettings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return Consumer(
              builder: (context, ref, child) {
                final settingsData =
                    ref.watch(SettingsNotifier.settingsProvider);
                return ListView(
                  children: [
                    SettingsSection(
                      title: translations.general,
                      tiles: [
                        OptionCheckbox(
                          title: translations.animations,
                          description:
                              translations.animations_details_settings_details,
                          onChanged:
                              settingsProvider.toggleSetAnimationsEnabled,
                          value: settingsData.isAnimationsEnabled,
                          leading: const PlatformAdaptiveIcon(
                            iconData: Icons.play_circle_outline,
                            cupertinoIconData: CupertinoIcons.play_arrow,
                          ),
                        ),
                        PlatformListTile(
                          onTap: () => showPlatformDialog(
                            context: context,
                            builder: (context) => const SelectThemeDialog(),
                          ),
                          title: Text(translations.theme_mode),
                          subtitle:
                              Text(translations.theme_mode_settings_details),
                          leading: const PlatformAdaptiveIcon(
                            iconData: Icons.wb_sunny_outlined,
                            cupertinoIconData: CupertinoIcons.sun_max,
                          ),
                        ),
                      ],
                    ),
                    SettingsSection(
                      title: translations.shopping_cart,
                      tiles: [
                        OptionCheckbox(
                          title: translations.confirm_delete_cart_item,
                          description: translations
                              .confirm_delete_cart_item_settings_details,
                          onChanged:
                              settingsProvider.toggleConfirmDeleteCartItem,
                          value: settingsData.confirmDeleteCartItem,
                          leading: const PlatformAdaptiveIcon(
                            iconData: Icons.delete_outline,
                            cupertinoIconData: CupertinoIcons.delete,
                          ),
                        ),
                        OptionCheckbox(
                          title: translations.clear_cart_after_checkout,
                          description: translations
                              .clear_cart_after_checkout_settings_details,
                          onChanged:
                              settingsProvider.toggleClearCartAfterCheckout,
                          value: settingsData.clearCartAfterCheckout,
                          leading: const PlatformAdaptiveIcon(
                            iconData: Icons.clear,
                            cupertinoIconData: CupertinoIcons.clear,
                          ),
                        ),
                      ],
                    ),
                    SettingsSection(
                      title: translations.statistics,
                      tiles: [
                        OptionCheckbox(
                          title: translations.force_use_scrollable_chart,
                          description: translations
                              .force_use_scrollable_chart_settings_details,
                          onChanged:
                              settingsProvider.toggleForceUseScrollableChart,
                          value: settingsData.forceUseScrollableChart,
                          leading: const Icon(
                            Icons.tune,
                          ),
                        ),
                        OptionCheckbox(
                          title: translations.prefer_numbers_in_chart_months,
                          description: translations
                              .prefer_numbers_in_chart_months_settings_details,
                          onChanged:
                              settingsProvider.toggleUseMonthNumberInChart,
                          value: settingsData.useMonthNumberInChart,
                          leading: const PlatformAdaptiveIcon(
                            iconData: Icons.insert_chart_outlined,
                            cupertinoIconData: CupertinoIcons.chart_bar,
                          ),
                        ),
                      ],
                    ),
                    SettingsSection(
                      title: translations.support,
                      tiles: [
                        OptionCheckbox(
                          title: translations.un_focus_after_send_message,
                          description: translations
                              .un_focus_after_send_message_settings_details,
                          onChanged: settingsProvider.toggleUnFocusAfterSendMsg,
                          value: settingsData.unFocusAfterSendMsg,
                          leading: const PlatformAdaptiveIcon(
                            iconData: Icons.send,
                            cupertinoIconData: CupertinoIcons.paperplane,
                          ),
                        ),
                        OptionCheckbox(
                          title: translations.use_classic_message_bubble,
                          description: translations
                              .use_classic_message_bubble_settings_details,
                          onChanged: settingsProvider.toggleUseClassicMsgBubble,
                          value: settingsData.useClassicMsgBubble,
                          leading: const PlatformAdaptiveIcon(
                            iconData: Icons.chat_bubble,
                            cupertinoIconData: CupertinoIcons.chat_bubble,
                          ),
                        ),
                      ],
                    ),
                    SettingsSection(
                      title: translations.orders,
                      tiles: [
                        OptionCheckbox(
                          title: translations.show_order_item_notes,
                          description: translations
                              .show_order_item_notes_settings_details,
                          onChanged: settingsProvider.toggleShowOrderItemNotes,
                          value: settingsData.showOrderItemNotes,
                          leading: const PlatformAdaptiveIcon(
                            iconData: Icons.description,
                            cupertinoIconData: CupertinoIcons.doc_text,
                          ),
                        ),
                      ],
                    ),
                    SettingsSection(
                      title: translations.data,
                      tiles: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              PlatformElevatedButton(
                                onPressed: FavoriteService.clearAllFavorites,
                                child: Text(translations.reset_favorites),
                                cupertino: (context, platform) =>
                                    CupertinoElevatedButtonData(
                                  padding: const EdgeInsets.all(8),
                                ),
                              ),
                              PlatformElevatedButton(
                                onPressed: () async {
                                  await settingsProvider.clearAllPrefs(
                                      context, ref);
                                  Future.microtask(
                                      () => Navigator.of(context).pop());
                                },
                                child: Text(translations.clear_preferences),
                                cupertino: (context, platform) =>
                                    CupertinoElevatedButtonData(
                                  padding: const EdgeInsets.all(8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SettingsSection(
                      title: translations.about_app,
                      tiles: [
                        const AboutAppListTile(),
                        Align(
                          alignment: Alignment.center,
                          child: PlatformTextButton(
                            child: Text(
                                translations.developed_by_with_developer_name(
                                    'Ahmed Hnewa')),
                            onPressed: () =>
                                UrlLauncherService.instance.launchStringUrl(
                              ServerConfigurations.developerUrl,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class AboutAppListTile extends StatefulWidget {
  const AboutAppListTile({super.key});

  @override
  State<AboutAppListTile> createState() => AboutAppListTileState();
}

class AboutAppListTileState extends State<AboutAppListTile> {
  late final Future<PackageAppDataInfo> _loadDataFuture;

  @override
  void initState() {
    super.initState();
    _loadDataFuture = PackageAppDataService.instance.loadPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    final translations = context.loc;
    return FutureBuilder(
      future: _loadDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        final packageDataInfo = snapshot.requireData;
        return PlatformListTile(
          title: Text(
            '${translations.app_name} ${packageDataInfo.buildName} (${packageDataInfo.buildNumber})',
            textAlign: TextAlign.center,
          ),
          leading: const PlatformAdaptiveIcon(
            cupertinoIconData: Icons.apple,
            iconData: Icons.android,
          ),
          onTap: () => showAboutDialog(context: context),
        );
      },
    );
  }
}
