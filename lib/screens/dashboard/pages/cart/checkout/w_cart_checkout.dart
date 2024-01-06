import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../../../cubits/p_order.dart';
import '../../../../../cubits/settings/settings_cubit.dart';
import '../../../../../data/order/m_order.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../services/native/connectivity_checker/s_connectivity_checker.dart';
import '../../../../../utils/extensions/build_context.dart';
import '../../../../../widgets/errors/w_internet_error.dart';
import '/screens/dashboard/pages/cart/checkout/w_payment_method.dart';
import '/widgets/adaptive/messenger.dart';

class CheckoutModalDialog extends ConsumerStatefulWidget {
  const CheckoutModalDialog({super.key});

  @override
  ConsumerState<CheckoutModalDialog> createState() =>
      _CheckoutModalDialogState();
}

class _CheckoutModalDialogState extends ConsumerState<CheckoutModalDialog> {
  late final TextEditingController _orderNotesController;
  final _formKey = GlobalKey<FormState>();
  var _error = '';
  var _isLoading = false;
  var _selectedPaymentMethod = PaymentMethod.cash;

  @override
  void initState() {
    super.initState();
    _orderNotesController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _orderNotesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final translations = context.loc;
    final orderProvider = ref.read(OrdersNotifier.ordersProvider.notifier);
    _error = '';
    _formKey.currentState?.validate() ??
        false; // No need for validations but still

    final hasConnection =
        await ConnectivityCheckerService.instance.hasConnection();
    if (!context.mounted) {
      return;
    }
    final settingsState = context.read<SettingsCubit>().state;
    if (!hasConnection) {
      showPlatformDialog(
        context: context,
        builder: (context) => const InternetErrorWithoutTryAgainDialog(),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await orderProvider.checkout(
        settingsState,
        ref,
        _orderNotesController.text,
        _selectedPaymentMethod,
      );
      await Future.microtask(() {
        Navigator.of(context).pop();
        if (_selectedPaymentMethod == PaymentMethod.cash) {
          AdaptiveMessenger.showPlatformMessage(
            context: context,
            message: translations.order_has_been_created,
            title: translations.success,
          );
        }
        // else {
        //   // checkout() will handle the rest...
        // }
      });
    } catch (e) {
      _error = e.toString();
      final hasConnection =
          await ConnectivityCheckerService.instance.hasConnection();
      if (!hasConnection ||
          (e is DioException && e.type == DioExceptionType.connectionError)) {
        _error = translations.please_check_your_internet_connection_msg;
      }
      setState(() {
        _selectedPaymentMethod = PaymentMethod.cash;
        _isLoading = false;
        _formKey.currentState?.validate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final translations = context.loc;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                  isCupertino(context)
                      ? CupertinoIcons.shopping_cart
                      : Icons.shopping_cart,
                  size: 50),
              Text(translations.checkout,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                    leadingDistribution: TextLeadingDistribution.even,
                  )),
              _isLoading
                  ? Lottie.asset(
                      Assets.lottie.loading1.path,
                      width: double.infinity,
                      height: 200,
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(translations.you_are_about_to_create_order),
                          const SizedBox(height: 2),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                PlatformTextFormField(
                                  controller: _orderNotesController,
                                  maxLines: 10,
                                  minLines: 1,
                                  validator: (value) => _error,
                                  textInputAction: TextInputAction.newline,
                                  keyboardType: TextInputType.multiline,
                                  hintText: translations.order_notes,
                                  material: (context, platform) =>
                                      MaterialTextFormFieldData(
                                    decoration: InputDecoration(
                                      labelText: translations.order_notes,
                                    ),
                                  ),
                                  cupertino: (context, platform) =>
                                      CupertinoTextFormFieldData(
                                    placeholder: translations.order_notes,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  translations.payment_method,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                PaymentMethodsSelector(
                                  onChanged: (paymentMethod) =>
                                      _selectedPaymentMethod = paymentMethod,
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      PlatformTextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text(translations.cancel),
                                      ),
                                      PlatformElevatedButton(
                                        onPressed: _isLoading ? null : _submit,
                                        child: Text(translations.confirm),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 2),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
