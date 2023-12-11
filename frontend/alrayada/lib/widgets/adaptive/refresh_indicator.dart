import 'package:flutter/cupertino.dart' show CupertinoSliverRefreshControl;
import 'package:flutter/material.dart' show RefreshCallback, RefreshIndicator;
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class AdaptiveRefreshIndicator extends StatelessWidget {
  const AdaptiveRefreshIndicator(
      {Key? key, required this.onRefresh, required this.child})
      : super(key: key);
  final RefreshCallback onRefresh;

  /// The child should not be scrollable since it already by default
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (isCupertino(context)) {
      return CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: onRefresh,
          ),
          SliverToBoxAdapter(
            child: child,
          )
        ],
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: child,
      ),
    );
  }
}
