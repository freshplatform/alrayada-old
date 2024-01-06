import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:shared_alrayada/server/server.dart';

import '../../cubits/settings/settings_cubit.dart';
import '../../data/favorite/s_favorite.dart';
import '../../services/native/package_app_data/package_app_data.dart';
import '../../services/native/url_launcher/s_url_launcher.dart';
import '../../utils/extensions/build_context.dart';
import '../../widgets/adaptive/w_icon.dart';
import '/screens/settings/w_select_theme_dialog.dart';
import '/services/native/package_app_data/s_package_app_data.dart';
import 'w_option_checkbox.dart';
import 'w_settings_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final translations = context.loc;
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(translations.settings),
      ),
      body: SafeArea(
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final settingsBloc = context.read<SettingsCubit>();
            return ListView(
              children: [
                SettingsSection(
                  title: translations.general,
                  tiles: [
                    OptionCheckbox(
                      title: translations.animations,
                      description:
                          translations.animations_details_settings_details,
                      onChanged: settingsBloc.toggleSetAnimationsEnabled,
                      value: state.isAnimationsEnabled,
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
                      subtitle: Text(translations.theme_mode_settings_details),
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
                      onChanged: settingsBloc.toggleConfirmDeleteCartItem,
                      value: state.confirmDeleteCartItem,
                      leading: const PlatformAdaptiveIcon(
                        iconData: Icons.delete_outline,
                        cupertinoIconData: CupertinoIcons.delete,
                      ),
                    ),
                    OptionCheckbox(
                      title: translations.clear_cart_after_checkout,
                      description: translations
                          .clear_cart_after_checkout_settings_details,
                      onChanged: settingsBloc.toggleClearCartAfterCheckout,
                      value: state.clearCartAfterCheckout,
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
                      onChanged: settingsBloc.toggleForceUseScrollableChart,
                      value: state.forceUseScrollableChart,
                      leading: const Icon(
                        Icons.tune,
                      ),
                    ),
                    OptionCheckbox(
                      title: translations.prefer_numbers_in_chart_months,
                      description: translations
                          .prefer_numbers_in_chart_months_settings_details,
                      onChanged: settingsBloc.toggleUseMonthNumberInChart,
                      value: state.useMonthNumberInChart,
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
                      onChanged: settingsBloc.toggleUnFocusAfterSendMsg,
                      value: state.unFocusAfterSendMsg,
                      leading: const PlatformAdaptiveIcon(
                        iconData: Icons.send,
                        cupertinoIconData: CupertinoIcons.paperplane,
                      ),
                    ),
                    OptionCheckbox(
                      title: translations.use_classic_message_bubble,
                      description: translations
                          .use_classic_message_bubble_settings_details,
                      onChanged: settingsBloc.toggleUseClassicMsgBubble,
                      value: state.useClassicMsgBubble,
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
                      description:
                          translations.show_order_item_notes_settings_details,
                      onChanged: settingsBloc.toggleShowOrderItemNotes,
                      value: state.showOrderItemNotes,
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
                              settingsBloc.clearAllPrefs();
                              Navigator.of(context).pop();
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
                        child: Text(translations
                            .developed_by_with_developer_name('Ahmed Hnewa')),
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
