import 'package:alrayada/core/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemNavigator;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/p_settings.dart';
import '../models/m_navigation_item.dart';
import 'w_material_drawer.dart';

class MaterialScaffoldDashbard extends ConsumerStatefulWidget {
  const MaterialScaffoldDashbard({super.key, required this.screens});

  final List<NavigationItem> screens;

  @override
  ConsumerState<MaterialScaffoldDashbard> createState() =>
      MaterialScaffoldDashbardState();
}

class MaterialScaffoldDashbardState
    extends ConsumerState<MaterialScaffoldDashbard> {
  late final PageController _pageViewController;
  var _currentIndex = 0;

  List<NavigationItem> get _screens => widget.screens;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  void navigateToNewItem(int newIndex) {
    // No need to change the current index since page view
    // will take care of that in onPageChanged
    final settingsData = ref.read(SettingsNotifier.settingsProvider);
    if (!settingsData.isAnimationsEnabled) {
      _pageViewController.jumpToPage(newIndex);
      return;
    }
    _pageViewController.animateToPage(
      newIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    // const useNavigationRail = true;
    return WillPopScope(
      onWillPop: () async =>
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(translations.close_the_app),
              content: Text(translations.close_the_app_msg),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(translations.no)),
                TextButton(
                    onPressed: () => SystemNavigator.pop(animated: true),
                    child: Text(translations.yes)),
              ],
            ),
          ) ??
          false,
      child: Scaffold(
        drawer: DashboardMaterialDrawer(translations: translations),
        floatingActionButton: (_screens[_currentIndex].body as NavigationData)
            .navigationItemData(context, ref)
            .materialFloatingActionButton,
        appBar: AppBar(
          title: Text(_screens[_currentIndex].label),
          actions: (_screens[_currentIndex].body as NavigationData)
              .navigationItemData(context, ref)
              .actions,
        ),
        body: Builder(builder: (context) {
          final useNavigationRail = MediaQuery.sizeOf(context).width > 500;
          final pageView = PageView(
            controller: _pageViewController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            children: _screens.map((e) => e.body).toList(),
          );
          if (useNavigationRail) {
            return Row(
              children: [
                NavigationRail(
                  labelType: NavigationRailLabelType.selected,
                  destinations: _screens
                      .map((e) => e.toNavigationRailDestination())
                      .toList(),
                  selectedIndex: _currentIndex,
                  onDestinationSelected: navigateToNewItem,
                ),
                Expanded(
                  child: pageView,
                ),
              ],
            );
          }
          return pageView;
        }),
        bottomNavigationBar: Builder(builder: (context) {
          final useNavigationRail = MediaQuery.sizeOf(context).width > 500;
          return useNavigationRail
              ? const SizedBox.shrink()
              : NavigationBar(
                  onDestinationSelected: navigateToNewItem,
                  selectedIndex: _currentIndex,
                  destinations:
                      _screens.map((e) => e.toNavigationDestination()).toList(),
                );
        }),
      ),
    );
  }
}
