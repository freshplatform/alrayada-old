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
  final List<Widget> actions;
  final Widget? materialFloatingActionButton;

  const NavigationItemData(
      {required this.actions, this.materialFloatingActionButton});
}

@immutable
abstract class NavigationData {
  final NavigationItemData Function(BuildContext context, WidgetRef ref)
      navigationItemData;

  const NavigationData(this.navigationItemData);
}

@immutable
class NavigationItem {
  final Widget body;
  final String label;
  final Widget icon;

  const NavigationItem({
    required this.body,
    required this.label,
    required this.icon,
  });

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
