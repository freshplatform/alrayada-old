import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/m_navigation_item.dart';

class CupertinoScaffoldDashboard extends ConsumerStatefulWidget {
  const CupertinoScaffoldDashboard({required this.screens, super.key});
  final List<NavigationItem> screens;

  @override
  ConsumerState<CupertinoScaffoldDashboard> createState() =>
      CupertinoScaffoldDashboardState();
}

class CupertinoScaffoldDashboardState
    extends ConsumerState<CupertinoScaffoldDashboard> {
  late final CupertinoTabController _cupertinoTabController;

  List<NavigationItem> get _screens => widget.screens;

  @override
  void initState() {
    super.initState();
    _cupertinoTabController = CupertinoTabController();
  }

  @override
  void dispose() {
    _cupertinoTabController.dispose();
    super.dispose();
  }

  void navigateToNewItem(int newIndex) {
    _cupertinoTabController.index = newIndex;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: _cupertinoTabController,
      tabBar: CupertinoTabBar(
        items: _screens.map((e) => e.toBottomNavigationBarItem()).toList(),
      ),
      tabBuilder: (context, index) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            padding: EdgeInsetsDirectional.zero,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: (_screens[index].body as NavigationData)
                  .navigationItemData(context, ref)
                  .actions,
            ),
            middle: Text(_screens[index].label),
          ),
          child: SafeArea(
            child: _screens[index].body,
          ),
        );
      },
    );
  }
}
