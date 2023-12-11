import 'dart:io' show HttpStatus;

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/user/auth/m_auth_request_response.dart';
import 'package:shared_alrayada/data/user/m_user.dart';

import '/core/locales.dart';
import '/screens/auth/forgot_password/w_auth_forgot_password.dart';
import '/screens/auth/social_login/w_social_login.dart';
import '/services/native/connectivity_checker/s_connectivity_checker.dart';
import '/utils/validators/auth_validators.dart';
import '/utils/validators/global_validators.dart';
import '/widgets/adaptive/messenger.dart';
import '/widgets/buttons/w_rounded_button.dart';
import '/widgets/errors/w_internet_error.dart';
import '/widgets/inputs/city_picker/w_city_dropdown.dart';
import '/widgets/inputs/password/w_password.dart';
import '../../providers/p_user.dart';

class AuthFormInputs extends ConsumerStatefulWidget {
  const AuthFormInputs({
    Key? key,
    required this.onIsLoginChange,
  }) : super(key: key);

  final Function(bool isLogin) onIsLoginChange;

  @override
  ConsumerState<AuthFormInputs> createState() => _AuthFormInputsState();
}

class _AuthFormInputsState extends ConsumerState<AuthFormInputs> {
  // Form
  final _formKey = GlobalKey<FormState>();
  var _authRequest = const AuthRequest(
    email: '',
    password: '',
    deviceToken: UserDeviceNotificationsToken(),
    userData: null,
  );
  var _isLogin = true;
  var _isAuthRequestLoading = false;

  // change _isAuthRequestLoading state quickly
  void setLoading(bool value) => setState(() => _isAuthRequestLoading = value);

  // Form Inputs
  var _emailError = '';
  var _passwordError = '';
  late final TextEditingController _passwordController;

  // Animations
  static const _fieldsSlideAnimationDuration = 290; // in milliseconds
  static const _fieldsOpacityAnimationDuration = 300; // in milliseconds
  static const _toggleSignupFieldsDuration = 290; // in milliseconds
  var _confirmPasswordOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordFocus.dispose();
    _ownerPhoneNumberFocusNode.dispose();
    super.dispose();
  }

  void _submit() {
    // Reset the errors that is from the server
    _emailError = '';
    _passwordError = '';
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;
    _formKey.currentState!.save();
    _isLogin ? _signIn() : _signup();
  }

  Future<void> _tryAuthenticate(
    bool isLogin,
    AuthRequest authRequest,
  ) async {
    final translations = AppLocalizations.of(context)!;

    final userProvider = ref.read(UserNotifier.provider.notifier);
    final hasConnection =
        await ConnectivityCheckerService.instance.hasConnection();
    if (!hasConnection) {
      Future.microtask(
        () => showPlatformDialog(
          context: context,
          builder: (context) => const InternetErrorWithoutTryAgainDialog(),
        ),
      );
      return;
    }
    setLoading(true);
    try {
      await userProvider.authenticateWithEmailAndPassword(isLogin, authRequest);
      _formKey.currentState?.reset();
      if (isLogin) {
        Future.microtask(() async {
          final navigator = Navigator.of(context);
          if (navigator.canPop()) {
            navigator.pop();
          } else {
            throw 'Error!';
          }
        });
        return;
      }
      _passwordController.clear();
      Future.microtask(() {
        showPlatformDialog<void>(
            context: context,
            builder: (context) {
              return PlatformAlertDialog(
                title: Text(translations.account_created),
                content: Text(translations.account_created_but),
                actions: [
                  PlatformDialogAction(
                    child: Text(translations.ok),
                    onPressed: () =>
                        Future.microtask(() => Navigator.of(context).pop()),
                  )
                ],
              );
            });
      });
    } on DioException catch (e) {
      final hasConnection =
          await ConnectivityCheckerService.instance.hasConnection();
      if (e.type == DioExceptionType.connectionError || !hasConnection) {
        Future.microtask(() => showPlatformDialog(
              context: context,
              builder: (context) => const InternetErrorWithoutTryAgainDialog(),
            ));
        return;
      }

      final errorMessage = e.response?.data.toString() ?? 'Unknown error';
      if (errorMessage.toLowerCase().contains('email')) {
        _emailError = errorMessage
            .replaceAll(
                'Email not found. Please check your email address and try again.',
                translations.auth_email_not_found)
            .replaceAll(
                'Email already in use. Please use a different email or try logging in.',
                translations.auth_email_already_in_use)
            .replaceAll(
                'An error occurred while sending the email verification link, please try again by sign in or contact us',
                translations.auth_email_verification_has_not_sent_error);
        _formKey.currentState?.validate();
        return;
      }
      if (errorMessage.toLowerCase().contains('password')) {
        _passwordError = errorMessage.replaceAll(
            'Incorrect password.', translations.incorrect_password);
        _formKey.currentState?.validate();
        return;
      }

      var message = (e.response?.data) ?? translations.unknown_error;
      if (message is String &&
          message.contains('Verification link is already sent,')) {
        String inputString = message;

        RegExp regExp = RegExp(r'\d+');

        final match = regExp.firstMatch(inputString);
        if (match != null) {
          final numberPart = match.group(0);
          if (numberPart != null) {
            message = translations
                .verification_link_is_already_sent_with_minutes_to_expire(
                    numberPart);
          }
        }
      }
      if (e.response?.statusCode == HttpStatus.tooManyRequests) {
        message = translations.auth_too_many_failed_attempts;
      }
      Future.microtask(() => AdaptiveMessenger.showPlatformMessage(
            context: context,
            title: translations.error,
            message: message,
            useSnackBarInMaterial: false,
          ));
    } finally {
      setLoading(false);
    }
  }

  void _signIn() async {
    _tryAuthenticate(true, _authRequest);
  }

  void _signup() async {
    final translations = AppLocalizations.of(context)!;
    final result = await showPlatformDialog<bool>(
          context: context,
          builder: (context) => PlatformAlertDialog(
            title: Text(translations.create_new_account),
            content: Text(
                translations.auth_are_you_sure_want_to_continue_create_account),
            actions: [
              PlatformDialogAction(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(translations.cancel),
              ),
              PlatformDialogAction(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(translations.ok),
              ),
            ],
          ),
        ) ??
        false;
    if (!result) {
      return;
    }
    _tryAuthenticate(false, _authRequest);
  }

  void _toggleLogin() async {
    if (_isLogin) {
      // flip, remember that _isLogin is not flipped yet
      _authRequest = _authRequest.copyWith(
        userData: const UserData(
          labOwnerPhoneNumber: '',
          labPhoneNumber: '',
          labName: '',
          labOwnerName: '',
          city: IraqGovernorate.baghdad,
        ),
      );

      setState(() {
        _confirmPasswordOpacity = 1;
        _isLogin = false; // signup
      });
      widget.onIsLoginChange(_isLogin);
      await Future.delayed(
        const Duration(milliseconds: _fieldsOpacityAnimationDuration),
      );
      return;
    }
    _authRequest = _authRequest.copyWith(userData: null);
    setState(() {
      _confirmPasswordOpacity = 0;
      _isLogin = true; // signIn
    });
    widget.onIsLoginChange(_isLogin);
  }

  final _confirmPasswordFocus = FocusNode();
  final _ownerPhoneNumberFocusNode = FocusNode();

  List<Widget> _signUpTextFields() {
    final translations = AppLocalizations.of(context)!;
    return [
      PasswordTextFormField(
        materialIcon: const Icon(Icons.lock),
        cupertinoIcon: const Icon(CupertinoIcons.lock_fill),
        focusNode: _confirmPasswordFocus,
        nextFocus: _ownerPhoneNumberFocusNode,
        validator: (value) => AuthValidators.validateConfirmPassword(
          password: _passwordController.text,
          confirmPassword: value,
          context: context,
        ),
        labelText: translations.confirm_password,
      ),
      ...userDataTextFields(
        context: context,
        onLabOwnerPhoneNumberSaved: (value) => _authRequest =
            _authRequest.copyWith(
                userData: _authRequest.userData
                    ?.copyWith(labOwnerPhoneNumber: value ?? '')),
        onLabPhoneNumberSaved: (value) => _authRequest = _authRequest.copyWith(
            userData:
                _authRequest.userData?.copyWith(labPhoneNumber: value ?? '')),
        onLabNameSaved: (value) => _authRequest = _authRequest.copyWith(
            userData: _authRequest.userData?.copyWith(labName: value ?? '')),
        onLabOwnerNameSaved: (value) => _authRequest = _authRequest.copyWith(
            userData:
                _authRequest.userData?.copyWith(labOwnerName: value ?? '')),
        onCitySaved: (value) => _authRequest = _authRequest.copyWith(
            userData: _authRequest.userData
                ?.copyWith(city: value ?? IraqGovernorate.baghdad)),
        ownerPhoneNumberFocusNode: _ownerPhoneNumberFocusNode,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);
    final translations = AppLocalizations.of(context)!;
    final formInputs = [
      Semantics(
        label: translations.email_address,
        child: PlatformTextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          enableSuggestions: true,
          autofillHints: const [AutofillHints.email],
          textCapitalization: TextCapitalization.none,
          hintText: translations.email_address,
          cupertino: (_, __) => CupertinoTextFormFieldData(
            prefix: const Icon(CupertinoIcons.mail),
            placeholder: translations.email_address,
          ),
          material: (_, __) => MaterialTextFormFieldData(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.mail),
              labelText: translations.email_address,
            ),
          ),
          minLines: 1,
          maxLines: 1,
          onSaved: (value) =>
              _authRequest = _authRequest.copyWith(email: value ?? ''),
          validator: (value) {
            if (_emailError.isNotEmpty) {
              return _emailError;
            }
            return AuthValidators.validateEmail(value, context);
          },
        ),
      ),
      Semantics(
        label: translations.password,
        child: PasswordTextFormField(
          materialIcon: const Icon(Icons.lock_outlined),
          cupertinoIcon: const Icon(CupertinoIcons.padlock),
          labelText: translations.password,
          controller: _passwordController,
          nextFocus: _isLogin ? null : _confirmPasswordFocus,
          onSaved: (value) =>
              _authRequest = _authRequest.copyWith(password: value ?? ''),
          textInputAction:
              _isLogin ? TextInputAction.done : TextInputAction.next,
          validator: (value) {
            if (_passwordError.isNotEmpty) {
              return _passwordError;
            }
            return AuthValidators.validatePassword(value, context);
          },
        ),
      ),
      AnimatedOpacity(
        curve: Curves.easeIn,
        opacity: _confirmPasswordOpacity,
        duration: const Duration(milliseconds: _fieldsOpacityAnimationDuration),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: _fieldsSlideAnimationDuration),
          transitionBuilder: (widget, animation) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: widget,
          ),
          child: !_isLogin
              ? Column(
                  children: _signUpTextFields(),
                )
              : const SizedBox(height: 200),
        ),
      ),
    ];
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Semantics(
            label: translations.auth_screen_form_inputs,
            child: PlatformWidget(
              material: (context, platform) => Column(
                children: formInputs,
              ),
              cupertino: (context, platform) =>
                  CupertinoFormSection.insetGrouped(
                margin: EdgeInsets.zero,
                backgroundColor: cupertinoTheme.barBackgroundColor,
                children: formInputs,
              ),
            ),
          ),
          AnimatedContainer(
            transform: Matrix4.translationValues(0, _isLogin ? -220 : 10, 0),
            duration: const Duration(milliseconds: _toggleSignupFieldsDuration),
            curve: Curves.easeOut,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 25),
                _isAuthRequestLoading
                    ? const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: PlatformTextButton(
                                onPressed: () async {
                                  final success =
                                      await showPlatformDialog<bool>(
                                            context: context,
                                            builder: (context) =>
                                                const ForgotPasswordDialog(),
                                          ) ??
                                          false;
                                  if (!success) {
                                    return;
                                  }
                                  Future.microtask(() {
                                    AdaptiveMessenger.showPlatformMessage(
                                      context: context,
                                      message: 'Please check your email inbox.',
                                      useSnackBarInMaterial: false,
                                      title: 'Success',
                                    );
                                  });
                                },
                                child: Text(translations.forgot_password),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Semantics(
                            label: _isLogin
                                ? translations.sign_in
                                : translations.sign_up,
                            child: AdaptiveRoundedButton(
                              type: RoundedButtonType.elevated,
                              onPressed: _submit,
                              child: Text(_isLogin
                                  ? translations.sign_in
                                  : translations.sign_up),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Semantics(
                            label: _isLogin
                                ? translations.dont_have_account_yet
                                : translations.already_have_account,
                            child: AdaptiveRoundedButton(
                              type: RoundedButtonType.outlined,
                              onPressed: _toggleLogin,
                              child: Text(_isLogin
                                  ? translations.dont_have_account_yet
                                  : translations.already_have_account),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 18),
                const SocialLogin(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> userDataTextFields({
  required BuildContext context,
  required FormFieldSetter<String> onLabOwnerPhoneNumberSaved,
  required FormFieldSetter<String> onLabPhoneNumberSaved,
  required FormFieldSetter<String> onLabNameSaved,
  required FormFieldSetter<String> onLabOwnerNameSaved,
  required FormFieldSetter<IraqGovernorate> onCitySaved,
  String labOwnerPhoneNumber = '',
  String labPhoneNumber = '',
  String labName = '',
  String labOwnerName = '',
  IraqGovernorate city = IraqGovernorate.baghdad,
  FocusNode? ownerPhoneNumberFocusNode,
}) {
  final translations = AppLocalizations.of(context)!;
  return [
    Row(
      children: [
        Expanded(
          child: Semantics(
            label: translations.lab_owner_phone_number,
            child: PlatformTextFormField(
              textInputAction: TextInputAction.next,
              maxLength: 11,
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              enableSuggestions: true,
              initialValue: labOwnerPhoneNumber,
              autofillHints: const [AutofillHints.telephoneNumberLocal],
              hintText: translations.lab_owner_phone_number,
              focusNode: ownerPhoneNumberFocusNode,
              cupertino: (_, __) => CupertinoTextFormFieldData(
                prefix: const Icon(CupertinoIcons.phone_fill),
                placeholder: translations.lab_owner_phone_number,
              ),
              material: (_, __) => MaterialTextFormFieldData(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  labelText: translations.lab_owner_phone_number,
                ),
              ),
              minLines: 1,
              maxLines: 1,
              onSaved: onLabOwnerPhoneNumberSaved,
              keyboardType: TextInputType.number,
              validator: (value) =>
                  AuthValidators.validatePhoneNumber(value, context),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Semantics(
            label: translations.lab_phone_number,
            child: PlatformTextFormField(
              textInputAction: TextInputAction.next,
              maxLength: 11,
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              keyboardType: TextInputType.number,
              enableSuggestions: true,
              hintText: translations.lab_phone_number,
              initialValue: labPhoneNumber,
              autofillHints: const [AutofillHints.telephoneNumberLocal],
              cupertino: (_, __) => CupertinoTextFormFieldData(
                prefix: const Icon(CupertinoIcons.phone),
                placeholder: translations.lab_phone_number,
              ),
              material: (_, __) => MaterialTextFormFieldData(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone_outlined),
                  labelText: translations.lab_phone_number,
                ),
              ),
              minLines: 1,
              maxLines: 1,
              onSaved: onLabPhoneNumberSaved,
              validator: (value) =>
                  AuthValidators.validatePhoneNumber(value, context),
            ),
          ),
        ),
      ],
    ),
    Semantics(
      label: translations.lab_name,
      child: PlatformTextFormField(
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.words,
        hintText: translations.lab_name,
        autofillHints: const [AutofillHints.location],
        initialValue: labName,
        cupertino: (_, __) => CupertinoTextFormFieldData(
          prefix: const Icon(CupertinoIcons.person_2_square_stack),
          placeholder: translations.lab_name,
        ),
        material: (_, __) => MaterialTextFormFieldData(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.location_history_rounded),
            labelText: translations.lab_name,
          ),
        ),
        minLines: 1,
        maxLines: 1,
        onSaved: onLabNameSaved,
        validator: (value) =>
            GlobalValidators.validateIsNotEmpty(value, context),
      ),
    ),
    Semantics(
      label: translations.lab_owner_name,
      child: PlatformTextFormField(
        textInputAction: TextInputAction.done,
        textCapitalization: TextCapitalization.words,
        hintText: translations.lab_owner_name,
        initialValue: labOwnerName,
        autofillHints: const [AutofillHints.name],
        cupertino: (_, __) => CupertinoTextFormFieldData(
          prefix: const Icon(CupertinoIcons.person),
          placeholder: translations.lab_owner_name,
        ),
        material: (_, __) => MaterialTextFormFieldData(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.location_history),
            labelText: translations.lab_owner_name,
          ),
        ),
        minLines: 1,
        maxLines: 1,
        onSaved: onLabOwnerNameSaved,
        validator: (value) =>
            GlobalValidators.validateIsNotEmpty(value, context),
      ),
    ),
    CityDropDownFormField(
      onSaved: onCitySaved,
      initialCity: city,
    ),
  ];
}
