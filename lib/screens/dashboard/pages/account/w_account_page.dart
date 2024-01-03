import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_alrayada/server/server.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../providers/p_user.dart';
import '../../../../services/native/url_launcher/s_url_launcher.dart';
import '../../../account_data/s_account_data.dart';
import '/core/locales.dart';
import '/screens/auth/s_auth.dart';
import '/screens/dashboard/models/m_navigation_item.dart';
import '/screens/favorites/s_favorites.dart';
import '/screens/notification/s_notification_list.dart';
import '/screens/settings/s_settings.dart';
import '/services/image/s_image.dart';
import '/widgets/adaptive/messenger.dart';
import '/widgets/adaptive/refresh_indicator.dart';
import '/widgets/adaptive/w_icon.dart';
import 'w_social_media_dialog.dart';

class AccountPage extends ConsumerStatefulWidget implements NavigationData {
  const AccountPage({required this.navigate, super.key});
  final Function(int newIndex) navigate;

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();

  @override
  NavigationItemData Function(BuildContext context, WidgetRef ref)
      get navigationItemData => (context, ref) {
            final translations = AppLocalizations.of(context)!;
            final actions = <Widget>[];
            actions.add(PlatformIconButton(
              onPressed: () => Navigator.of(context)
                  .pushNamed(NotificationListScreen.routeName),
              icon: const PlatformAdaptiveIcon(
                iconData: Icons.notifications,
                cupertinoIconData: CupertinoIcons.bell_fill,
              ),
              material: (context, _) =>
                  MaterialIconButtonData(tooltip: translations.notifications),
            ));
            return NavigationItemData(actions: actions);
          };
}

class _AccountPageState extends ConsumerState<AccountPage>
    with AutomaticKeepAliveClientMixin {
  late final Future<void> _loadUserFromServerFuture;

  @override
  void initState() {
    super.initState();
    _loadUserFromServerFuture =
        ref.read(UserNotifier.provider.notifier).loadUserFromServer();
    requestNotificationPermission();
  }

  Future<void> requestNotificationPermission() async {
    // TODO: Handle this permissions and push notification thing, fcm or one signal
    await Future.delayed(Duration.zero);
    // final translations =
    //     await Future.microtask(() => AppLocalizations.of(context)!);
    // final messaging = FirebaseMessaging.instance;
    // final notificationPermissionRequest = await messaging.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );

    final success = await OneSignal.Notifications.requestPermission(true);
    // if (success) {
    //   Future.microtask(() {
    //     AdaptiveMessenger.showPlatformMessage(
    //       context: context,
    //       message: translations.notifications_permission_message,
    //       title: translations.notifications_permission_title,
    //       useSnackBarInMaterial: false,
    //     );
    //   });
    // }
    if (kDebugMode) {
      print(
        'User granted notification permission: $success',
      );
    }
  }

  Widget _buildAccountItem({
    required String title,
    required String subTitle,
    required IconData iconData,
    VoidCallback? onTap,
  }) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    );
    final listTile = PlatformListTile(
      onTap: onTap,
      title: Text(title),
      trailing: Icon(
        PlatformIcons(context).forward,
        semanticLabel: 'Open $title page',
      ),
      leading: Icon(
        iconData,
        semanticLabel: title,
      ),
      subtitle: Text(subTitle),
      material: (context, platform) => MaterialListTileData(
        shape: shape,
      ),
    );
    return Semantics(
      label: title,
      child: isMaterial(context)
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Card(
                shape: shape,
                child: listTile,
              ),
            )
          : Container(
              margin: const EdgeInsets.all(6),
              child: listTile,
            ),
    );
  }

  void _notLoginMessage() {
    final translations = AppLocalizations.of(context)!;
    AdaptiveMessenger.showPlatformMessage(
      context: context,
      message: translations.you_need_to_login_first,
      title: translations.not_authenticated,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final cupertinoTheme = CupertinoTheme.of(context);
    final materialTheme = Theme.of(context);
    final translations = AppLocalizations.of(context)!;
    // final currentUserContainer = ref.read(UserNotifier.userProvider);

    final notAuthenticatedItems = Column(
      children: [
        _buildAccountItem(
          title: translations.account_data,
          subTitle: translations.update_all_of_your_data,
          iconData: PlatformIcons(context).accountCircleSolid,
        ),
        _buildAccountItem(
          title: translations.orders,
          subTitle: translations.view_all_of_your_orders,
          iconData: PlatformIcons(context).shoppingCart,
        ),
      ],
    );

    return AdaptiveRefreshIndicator(
      onRefresh: () async {
        final userContainer = ref.read(UserNotifier.provider);
        if (userContainer != null) {
          final userProvider = ref.read(UserNotifier.provider.notifier);
          await userProvider.loadUserFromServer();
        }
      },
      child: Column(
        children: [
          Consumer(
            builder: (context, ref, _) {
              final userContainer = ref.watch(UserNotifier.provider);
              final user = userContainer?.user;
              final userData = user?.data;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (user != null)
                      Stack(
                        children: [
                          user.pictureUrl.isEmpty
                              ? const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 47,
                                  child: Icon(
                                    Icons.person,
                                    size: 60,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 47,
                                  backgroundImage: CachedNetworkImageProvider(
                                    ImageService.getImageByImageServerRef(
                                      user.pictureUrl,
                                    ),
                                  ),
                                ),
                          if (user.accountActivated)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: PlatformAdaptiveIcon(
                                iconData: Icons.verified_sharp,
                                color: isMaterial(context) ? Colors.blue : null,
                                cupertinoIconData:
                                    CupertinoIcons.checkmark_seal_fill,
                              ),
                            ),
                        ],
                      )
                    else
                      Lottie.asset(
                        Assets.lottie.auth1.path,
                        width: 230,
                        alignment: Alignment.bottomCenter,
                      ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        if (userData != null) ...[
                          Text(
                            translations.welcome_again_with_lab_name(
                              userData.labOwnerName,
                            ),
                            style: isCupertino(context)
                                ? cupertinoTheme.textTheme.navTitleTextStyle
                                : materialTheme.textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 3)
                        ],
                        user != null
                            ? Text(
                                translations.joined_in_with_date(
                                    DateFormat.yMMMMEEEEd()
                                        .format(user.createdAt)),
                                style: isCupertino(context)
                                    ? cupertinoTheme.textTheme.navTitleTextStyle
                                        .copyWith(color: Colors.grey)
                                    : materialTheme.textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              )
                            : PlatformTextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(AuthScreen.routeName);
                                },
                                child: Text(translations.sign_in),
                              )
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          FutureBuilder(
            future: _loadUserFromServerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return notAuthenticatedItems;
              }
              if (snapshot.hasError) {
                return notAuthenticatedItems;
              }
              return Consumer(
                builder: (context, ref, _) {
                  final newUserContainer = ref.watch(UserNotifier.provider);
                  // if (newUserContainer == null &&
                  //     currentUserContainer != null) {
                  //   // TODO("Translate this too")
                  //   // AdaptiveMessenger.showPlatformMessage(
                  //   //   context: context,
                  //   //   message: 'Your account exists no more!',
                  //   //   title: 'Not authenticated!',
                  //   //   useSnackBarInMaterial: false,
                  //   // );
                  // }
                  return Column(
                    children: [
                      _buildAccountItem(
                        title: translations.account_data,
                        subTitle: translations.update_all_of_your_data,
                        iconData: PlatformIcons(context).accountCircleSolid,
                        onTap: newUserContainer != null
                            ? () => Navigator.of(context)
                                .pushNamed(AccountDataScreen.routeName)
                            : _notLoginMessage,
                      ),
                      _buildAccountItem(
                        title: translations.orders,
                        subTitle: translations.view_all_of_your_orders,
                        iconData: PlatformIcons(context).shoppingCart,
                        onTap: () => widget.navigate(
                            3), // TODO("Consider a solution for index changing")
                      ),
                    ],
                  );
                },
              );
            },
          ),
          _buildAccountItem(
            title: translations.favorites,
            subTitle: translations.view_all_of_your_wishlist,
            iconData: PlatformIcons(context).favoriteOutline,
            onTap: () =>
                Navigator.of(context).pushNamed(FavoritesScreen.routeName),
          ),
          _buildAccountItem(
            title: translations.privacy_policy,
            subTitle: translations.open_privacy_policy_page,
            iconData: PlatformIcons(context).padlockSolid,
            onTap: () async => await UrlLauncherService.instance
                .launchStringUrl(ServerConfigurations.privacyPolicy),
          ),
          _buildAccountItem(
            title: translations.social_media,
            subTitle: translations.follow_us_on_social_media,
            iconData: PlatformIcons(context).share,
            onTap: () => showPlatformDialog(
                context: context,
                builder: (context) => const SocialMediaLinksDialog()),
          ),
          _buildAccountItem(
            title: translations.settings,
            subTitle: translations.select_your_preferences,
            iconData: PlatformIcons(context).settings,
            onTap: () =>
                Navigator.of(context).pushNamed(SettingsScreen.routeName),
          ),
          Consumer(
            builder: (context, ref, _) {
              final userContainer = ref.watch(UserNotifier.provider);
              final userProvider = ref.read(UserNotifier.provider.notifier);
              if (userContainer == null) {
                return const SizedBox.shrink(); // no logout button
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: PlatformWidget(
                    cupertino: (context, platform) => CupertinoButton(
                      onPressed: () => userProvider.logout(byUser: true),
                      child: Text(translations.logout),
                    ),
                    material: (context, platform) => OutlinedButton(
                      onPressed: () => userProvider.logout(byUser: true),
                      child: Text(translations.logout),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
