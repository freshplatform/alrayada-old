import 'package:alrayada/utils/platform_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/screens/dashboard/models/m_navigation_item.dart';
import '/widgets/adaptive/w_appbar.dart';

class AdaptiveTabScaffold extends StatefulWidget {
  const AdaptiveTabScaffold({
    Key? key,
    required this.items,
    this.onNavigate = _defaultOnNavigateValue,
    this.actions,
  }) : super(key: key);
  final List<Widget>? actions;
  final List<NavigationItem> items;
  final Function(int newIndex) onNavigate;

  static _defaultOnNavigateValue(int newIndex) {}

  @override
  State<AdaptiveTabScaffold> createState() => _AdaptiveTabScaffoldState();
}

class _AdaptiveTabScaffoldState extends State<AdaptiveTabScaffold> {
  var _selectedIndex = 0;
  NavigationItem _currentScreen() => widget.items[_selectedIndex];

  final PageStorageBucket bucket = PageStorageBucket();
  void _selectMaterialScreen(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onNavigate(index);
  }

  List<BottomNavigationBarItem> _mapToBottomNavigationBarItem({
    Color? backgroundColor,
  }) =>
      widget.items.map((item) {
        return BottomNavigationBarItem(
          icon: item.icon,
          label: item.label,
          backgroundColor: backgroundColor,
        );
      }).toList();

  late PreferredSizeWidget appBar;

  @override
  Widget build(BuildContext context) {
    appBar = adaptiveAppBar(
      context: context,
      title: Text(_currentScreen().label),
      actions: widget.actions,
    );
    final theme = Theme.of(context);
    final bottomNavigationBarTheme = theme.bottomNavigationBarTheme;
    return PlatformChecker.isAppleProduct()
        ? CupertinoPageScaffold(
            navigationBar: appBar as CupertinoNavigationBar,
            child: SafeArea(
              child: CupertinoTabScaffold(
                tabBar: CupertinoTabBar(
                  onTap: (newIndex) {
                    setState(() {
                      _selectedIndex = newIndex;
                    });
                    widget.onNavigate(newIndex);
                  },
                  items: _mapToBottomNavigationBarItem(),
                ),
                tabBuilder: (BuildContext context, int index) {
                  return widget.items[index].body;
                },
              ),
            ),
          )
        : Scaffold(
            body: PageStorage(
              bucket: bucket,
              child: _currentScreen().body,
            ),
            appBar: appBar,
            bottomNavigationBar: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: BottomNavigationBar(
                /* This backgroundColor is only work for BottomNavigationBarType.fixed */
                // backgroundColor: bottomNavigationBarTheme.backgroundColor,
                currentIndex: _selectedIndex,
                onTap: (index) => _selectMaterialScreen(index),
                items: _mapToBottomNavigationBarItem(
                  backgroundColor: bottomNavigationBarTheme.backgroundColor,
                ),
              ),
            ),
          );
  }
}
//
// class _ScaffoldMaterialBottomNavigation extends StatefulWidget {
//   const _ScaffoldMaterialBottomNavigation({
//     Key? key,
//     this.appBar,
//     required this.bottomNavigationItems,
//     required this.onNavigate,
//   }) : super(key: key);
//   final PreferredSizeWidget? appBar;
//   final List<BottomNavigationItem> bottomNavigationItems;
//   final Function(int newIndex) onNavigate;
//
//   @override
//   State<_ScaffoldMaterialBottomNavigation> createState() =>
//       _ScaffoldMaterialBottomNavigationState();
// }
//
// class _ScaffoldMaterialBottomNavigationState
//     extends State<_ScaffoldMaterialBottomNavigation> {
//   var _selectedIndex = 0;
//
//   BottomNavigationItem _currentItem() =>
//       widget.bottomNavigationItems[_selectedIndex];
//
//   @override
//   Widget build(BuildContext context) {
//
//   }
// }
