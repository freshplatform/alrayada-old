import 'package:flutter/material.dart' show Colors, TextButton;
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '/core/locales.dart';
import '/providers/p_settings.dart';
import '../../core/theme_data.dart';
import '../../gen/assets.gen.dart';
import '../dashboard/s_dashboard.dart';

class OnBoardingScreen extends ConsumerStatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  static const routeName = '/onBoarding';

  @override
  ConsumerState<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends ConsumerState<OnBoardingScreen> {
  late final PageController _controller;
  var _isLastPageReached = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildPage({
    required Color color,
    required String imagePath,
    required String title,
    required String subtitle,
  }) =>
      Semantics(
        label: title,
        child: Container(
          color: color,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: 400,
                  ),
                  const SizedBox(height: 64),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    textScaler: TextScaler.noScaling,
                    style: TextStyle(
                      color: Colors.teal.shade700,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(),
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    final settingsProvider =
        ref.read(SettingsNotifier.settingsProvider.notifier);
    final pages = [
      _buildPage(
        color: Colors.blue.shade100,
        imagePath: Assets.lottie.onlineShopping2.path,
        title: translations.online_shopping_made_easy_feature,
        subtitle: translations.online_shopping_made_easy_feature_details,
      ),
      _buildPage(
        color: Colors.green.shade100,
        imagePath: Assets.lottie.cloudSecurity1.path,
        title: translations.secure_shopping_experience_feature,
        subtitle: translations.secure_shopping_experience_feature_details,
      ),
      _buildPage(
        color: Colors.orange.shade100,
        imagePath: Assets.lottie.wishlist1.path,
        title: translations.favorites_wishlist_feature,
        subtitle: translations.favorites_wishlist_feature_details,
      ),
      _buildPage(
        color: Colors.greenAccent.shade100,
        imagePath: Assets.lottie.search1.path,
        title: translations.easy_filtering_and_searching_feature,
        subtitle: translations.easy_filtering_and_searching_feature_details,
      ),
      _buildPage(
        color: Colors.teal.shade100,
        imagePath: Assets.lottie.socialAuthentication1.path,
        title: translations.social_authentication_feature,
        subtitle: translations.social_authentication_feature_details,
      ),
      _buildPage(
        color: Colors.red.shade100,
        imagePath: Assets.lottie.fastDelivery1.path,
        title: translations.fast_shipping_feature,
        subtitle: translations.fast_shipping_feature_details,
      ),
      _buildPage(
        color: Colors.yellow.shade100,
        imagePath: Assets.lottie.support1.path,
        title: translations.in_app_support_chat_feature,
        subtitle: translations.in_app_support_chat_feature_details,
      ),
      _buildPage(
        color: Colors.green.shade100,
        imagePath: Assets.lottie.programming1.path,
        title: translations.under_development_feature,
        subtitle: translations.under_development_feature_details,
      ),
    ];

    return Semantics(
      label: translations.welcome_screen,
      child: PlatformScaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView(
                onPageChanged: (index) {
                  if (index != pages.length - 1) return;
                  setState(() => _isLastPageReached = true);
                },
                controller: _controller,
                children: pages,
              ),
            ),
            Container(
              padding: _isLastPageReached
                  ? null
                  : const EdgeInsets.symmetric(horizontal: 20),
              height: 80,
              child: _isLastPageReached
                  ? Semantics(
                      label: translations.get_started,
                      child: PlatformTextButton(
                        onPressed: () async {
                          await settingsProvider.dontShowOnBoardingScreen();
                          Future.microtask(() => Navigator.of(context)
                              .pushReplacementNamed(DashboardScreen.routeName));
                        },
                        child: Text(translations.get_started),
                        material: (context, platform) => MaterialTextButtonData(
                          style: TextButton.styleFrom(
                            shape: const RoundedRectangleBorder(),
                            minimumSize: const Size(double.infinity, 80),
                          ),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Semantics(
                          label: translations.skip,
                          child: PlatformTextButton(
                            child: Text(translations.skip),
                            onPressed: () =>
                                _controller.jumpToPage(pages.length - 1),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SmoothPageIndicator(
                              controller: _controller,
                              count: pages.length,
                              onDotClicked: (index) =>
                                  _controller.animateToPage(index,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeIn),
                              effect: MyAppTheme.isDark(context, ref)
                                  ? const WormEffect(
                                      dotHeight: 20,
                                      dotWidth: 20,
                                    )
                                  : WormEffect(
                                      dotColor: Colors.black26,
                                      dotHeight: 20,
                                      dotWidth: 20,
                                      activeDotColor: Colors.teal.shade700,
                                    ),
                            ),
                          ),
                        ),
                        Semantics(
                          label: translations.next,
                          child: PlatformTextButton(
                            child: Text(translations.next),
                            onPressed: () => _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            ),
                          ),
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
