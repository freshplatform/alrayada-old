import 'package:flutter/material.dart'
    show
        BottomNavigationBarItem,
        BuildContext,
        NavigationDestination,
        NavigationRailDestination,
        Text,
        Widget,
        immutable;
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class NavigationItemData {

  const NavigationItemData(
      {required this.actions, this.materialFloatingActionButton});
  final List<Widget> actions;
  final Widget? materialFloatingActionButton;
}

@immutable
abstract class NavigationData {

  const NavigationData(this.navigationItemData);
  final NavigationItemData Function(BuildContext context, WidgetRef ref)
      navigationItemData;
}

@immutable
class NavigationItem {

  const NavigationItem({
    required this.body,
    required this.label,
    required this.icon,
  });
  final Widget body;
  final String label;
  final Widget icon;

  BottomNavigationBarItem toBottomNavigationBarItem() =>
      BottomNavigationBarItem(
        icon: icon,
        label: label,
        tooltip: label,
      );

  NavigationDestination toNavigationDestination() => NavigationDestination(
        icon: icon,
        label: label,
        tooltip: label,
      );

  NavigationRailDestination toNavigationRailDestination() =>
      NavigationRailDestination(
        icon: icon,
        label: Text(label),
        // tooltip: label,
      );
}
