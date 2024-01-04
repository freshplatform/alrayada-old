import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_alrayada/data/user/m_user.dart';
import 'package:shared_alrayada/server/server.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../extensions/build_context.dart';
import '../../../gen/assets.gen.dart';
import '../../../utils/constants/routes.dart';
import '/core/theme_data.dart';
import '/data/social_authentication/social_authentication.dart';
import '/providers/p_user.dart';
import '/screens/auth/social_login/w_signup_with_social_login_dialog.dart';
import '/widgets/adaptive/messenger.dart';
import '/widgets/buttons/w_outlined_button.dart';

class SocialLogin extends ConsumerStatefulWidget {
  const SocialLogin({super.key});

  @override
  ConsumerState<SocialLogin> createState() => _SocialLoginState();
}

class _SocialLoginState extends ConsumerState<SocialLogin> {
  var _isLoading = false;

  late final GoogleSignIn _googleSignIn;

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn(
      serverClientId: ServerConfigurations.googleAuthServerClientId,
      signInOption: SignInOption.standard,
      scopes: [
        'email',
        'profile',
      ],
    );
  }

  void setLoading(bool newValue) => setState(() => _isLoading = newValue);

  Future<void> _authenticateWithFacebook() async {
    final translationa = context.loc;
    AdaptiveMessenger.showPlatformMessage(
      context: context,
      message: translationa.sorry_this_feature_is_not_available_at_the_moment,
    );
    // final facebookAuth = FacebookAuth.instance;
    // final AccessToken? accessToken = await facebookAuth.accessToken;
    // if (accessToken != null) {
    //   await facebookAuth.logOut();
    // }
    // final result = await facebookAuth.login(
    //   permissions: [
    //     'email',
    //     'public_profile',
    //     // 'first_name',
    //     // 'last_name',
    //     // 'middle_name',
    //     // 'name',
    //     // 'picture',
    //     // 'short_name'
    //   ],
    // );
    // // or FacebookAuth.i.login()
    // // if (result.status == LoginStatus.success) {
    // //   final accessToken = result.accessToken!;
    // //   print(accessToken.toJson());
    // // } else {
    // //   print(result.status);
    // //   print(result.message);
    // // }
  }

  Future<void> _authenticateWithApple() async {
    final translations = context.loc;
    try {
      setLoading(true);

      final credential = await SignInWithApple.getAppleIDCredential(
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: ServerConfigurations.appleAuthServiceClientId,
          redirectUri: Uri.parse(
            RoutesConstants.authRoutes.signInWithAppleWebRedirectUrl,
          ),
        ),
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      if (credential.identityToken == null ||
          (credential.identityToken?.trim().isEmpty ?? true)) {
        setLoading(false);
        return;
      }
      var userIdentifier = credential.userIdentifier;
      final identityToken = credential.identityToken!;
      if (userIdentifier == null) {
        // TODO("This need to be watched")
        final tokenParts = identityToken.split('.');
        final encodedPayload = tokenParts[1];

        // Add padding if necessary (bug solved thanks to ChatGpt)
        final paddingLength = 4 - (encodedPayload.length % 4);
        final paddedPayload = encodedPayload + ('=' * paddingLength);

        final decodedPayload = utf8.decode(base64Url.decode(paddedPayload));
        final payloadMap = jsonDecode(decodedPayload);
        userIdentifier = payloadMap['sub'] as String;
      }
      final appleSocialAuth = AppleAuthentication(identityToken, userIdentifier,
          null, const UserDeviceNotificationsToken());
      final error = await ref
          .read(UserNotifier.provider.notifier)
          .authenticateWithSocialLogin(
            appleSocialAuth,
            AppleAuthentication.provider,
          );
      handleError(
        error: error,
        socialAuth: appleSocialAuth,
        provider: AppleAuthentication.provider,
        initialLabOwnerName: credential.givenName != null
            ? ('${credential.givenName} ${credential.familyName}')
            : '',
      );
    } on SignInWithAppleAuthorizationException catch (error) {
      if (error.code == AuthorizationErrorCode.canceled) return;
      if (error.code == AuthorizationErrorCode.unknown) return;
      Future.microtask(() => AdaptiveMessenger.showPlatformMessage(
            context: context,
            message: error.message,
            title: translations.error,
            useSnackBarInMaterial: false,
          ));
    } catch (e) {
      Future.microtask(() => AdaptiveMessenger.showPlatformMessage(
            context: context,
            title: translations.error,
            message: '${translations.unknown_error}: $e',
            useSnackBarInMaterial: false,
          ));
    } finally {
      setLoading(false);
    }
  }

  Future<void> _authenticateWithGoogle() async {
    setLoading(true);
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
    final googleResponse = await _googleSignIn.signIn();
    final auth = await googleResponse?.authentication;
    if (auth?.idToken == null || (auth!.idToken?.trim().isEmpty ?? true)) {
      setLoading(false);
      return;
    }
    final googleSocialAuth = GoogleAuthentication(
        auth.idToken!, null, const UserDeviceNotificationsToken());
    final error = await ref
        .read(UserNotifier.provider.notifier)
        .authenticateWithSocialLogin(
          googleSocialAuth,
          GoogleAuthentication.provider,
        );
    setLoading(false);
    handleError(
      socialAuth: googleSocialAuth,
      provider: GoogleAuthentication.provider,
      error: error,
      initialLabOwnerName: googleResponse?.displayName ?? '',
    );
  }

  void handleError({
    required String? error,
    required SocialAuthentication socialAuth,
    required String provider,
    String initialLabOwnerName = '',
  }) {
    final translations = context.loc;

    if (error != null) {
      if (error ==
          'There is no matching email account, so please provider sign up data to create the account') {
        Future.microtask(() => showPlatformDialog(
              context: context,
              builder: (context) {
                return SignUpWithSocialLoginDialog(
                  initialLabOwnerName: initialLabOwnerName,
                  provider: provider,
                  socialAuthentication: socialAuth,
                );
              },
            ));
        return;
      }
      Future.microtask(
        () => AdaptiveMessenger.showPlatformMessage(
          context: context,
          message: error.toString(),
          title: translations.error,
          useSnackBarInMaterial: false,
        ),
      );
      return;
    }
    Future.microtask(() => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    final materialTheme = Theme.of(context);
    final cupertinoTheme = CupertinoTheme.of(context);
    final translations = context.loc;
    const fontSize = 50 * 0.43;
    const appleIconSizeScale = 28 / 44;
    const double height = 44;
    final appleIcon = Container(
      width: appleIconSizeScale * height,
      height: appleIconSizeScale * height + 2,
      padding: const EdgeInsets.only(
        bottom: (4 / 44) * height,
      ),
      child: Center(
        child: SizedBox(
          width: fontSize * (25 / 31),
          height: fontSize,
          child: CustomPaint(
            painter: AppleLogoPainter(
              color:
                  MyAppTheme.isDark(context, ref) ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
    return Column(
      children: [
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              const Expanded(
                child: Divider(),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  translations.or_sign_in_using_social_media_account,
                  style: isCupertino(context)
                      ? cupertinoTheme.textTheme.actionTextStyle
                      : materialTheme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const Expanded(
                child: Divider(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        !_isLoading
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Semantics(
                        label: translations.login_with_facebook,
                        child: SizedBox(
                          width: 100,
                          child: AdaptiveOutlinedButton(
                            onPressed: _authenticateWithGoogle,
                            child: SvgPicture.asset(
                              Assets.svg.icGoogle.path,
                              width: 24,
                              semanticsLabel: translations.google_icon,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Semantics(
                        label: translations.login_with_apple,
                        child: SizedBox(
                          width: 100,
                          child: AdaptiveOutlinedButton(
                            onPressed: _authenticateWithApple,
                            child: appleIcon,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Semantics(
                    label: translations.login_with_facebook,
                    child: SizedBox(
                      width: 100,
                      child: AdaptiveOutlinedButton(
                        onPressed: _authenticateWithFacebook,
                        child: SvgPicture.asset(
                          Assets.svg.icFacebook.path,
                          width: 24,
                          semanticsLabel: translations.facebook_icon,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const CircularProgressIndicator.adaptive(),
      ],
    );
  }
}
