import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme_data.dart';
import '../../../../../data/order/m_order.dart';
import '/screens/dashboard/pages/orders/w_cancel_order.dart';

class OrderDetailsSteps extends ConsumerWidget {
  const OrderDetailsSteps({required this.order, super.key});
  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
      data: MyAppTheme.getAppMaterialTheme(context),
      child: Card(
        child: _OrderDetailsSteps(order),
      ),
    );
  }
}

class _OrderDetailsSteps extends StatefulWidget {
  const _OrderDetailsSteps(this.order);

  final Order order;

  @override
  State<_OrderDetailsSteps> createState() => _OrderDetailsStepsState();
}

class _OrderDetailsStepsState extends State<_OrderDetailsSteps> {
  var _currentStep = 0;

  Order get order => widget.order;

  Step _buildStep({
    required String title,
    required IconData titleIcon,
    required String subtitle,
    required bool isActive,
    required IconData leadingIcon,
    required DateTime trailingDate,
  }) {
    final now = DateTime.now();
    var formattedDate = DateFormat.yMMMd().format(trailingDate);
    if (trailingDate.day == now.day &&
        trailingDate.month == now.month &&
        trailingDate.year == now.year) {
      formattedDate = DateFormat.jm().format(trailingDate);
    }
    return Step(
      isActive: isActive,
      title: CircleAvatar(child: Icon(titleIcon)),
      content: ListTile(
        title: Text(
          title,
        ),
        subtitle: Text(
          subtitle,
        ),
        leading: Icon(leadingIcon),
        trailing: Text(
          formattedDate,
        ),
      ),
    );
  }

  IconData get _orderStatusIcon {
    switch (order.status) {
      // case OrderStatus.Process:
      //   return Icons.watch_later;
      case OrderStatus.approved:
        return Icons.check;
      case OrderStatus.rejected:
        return Icons.not_interested;
      case OrderStatus.cancelled:
        return Icons.cancel;
      // case OrderStatus.created:
      //   return Icons.create;
      case OrderStatus.pending:
        return Icons.pending;
    }
  }

  (String status, String message) get _orderStatusPair1 {
    if (order.status == OrderStatus.cancelled) {
      return ('Cancelled', 'You did cancel the order');
    }
    if (!order.isPaid) {
      return ('Created', 'Please pay using chosen payment method');
    }
    return (
      'Ordered',
      'We have received your order, please wait until we review it',
    );
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      _buildStep(
        title: _orderStatusPair1.$1,
        titleIcon:
            order.status == OrderStatus.cancelled ? Icons.cancel : Icons.done,
        subtitle: _orderStatusPair1.$2,
        isActive: _currentStep == 0,
        leadingIcon: order.status == OrderStatus.cancelled
            ? Icons.cancel
            : Icons.shopping_basket,
        trailingDate: order.status == OrderStatus.cancelled
            ? order.updatedAt
            : order.createdAt,
      ),
      // if (order.status != OrderStatus.pro &&
      if (order.status != OrderStatus.cancelled)
        _buildStep(
          title: order.status.name,
          titleIcon: _orderStatusIcon,
          subtitle: 'Your order has been ${order.status.name}',
          isActive: _currentStep == 1,
          leadingIcon: _orderStatusIcon,
          trailingDate: order.updatedAt,
        )
    ];
    if (isCupertino(context)) {
      CupertinoStepper(
        onStepTapped: (newIndex) => setState(() => _currentStep = newIndex),
        onStepContinue: () {
          if ((steps.length - 1) <= _currentStep) return;
          setState(() => _currentStep++);
        },
        onStepCancel: () async {
          final success = await showPlatformDialog<bool>(
                context: context,
                builder: (context) => CancelOrderDialog(order),
              ) ??
              false;
          if (!success) return;
          setState(() {});
        },
        currentStep: _currentStep,
        steps: steps,
      );
    }
    return Stepper(
      onStepTapped: (newIndex) => setState(() => _currentStep = newIndex),
      onStepContinue: () {
        if ((steps.length - 1) <= _currentStep) return;
        setState(() => _currentStep++);
      },
      onStepCancel: () async {
        final success = await showPlatformDialog<bool>(
              context: context,
              builder: (context) => CancelOrderDialog(order),
            ) ??
            false;
        if (!success) return;
        setState(() {});
      },
      currentStep: _currentStep,
      steps: steps,
    );
  }
}
