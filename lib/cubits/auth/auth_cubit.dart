import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/social_authentication/social_authentication.dart';
import '../../data/user/auth_repository.dart';
import '../../data/user/models/m_auth_credential.dart';
import '../../data/user/models/m_auth_request.dart';
import '../../data/user/models/m_user.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authRepository})
      : super(const AuthState(userCredential: null)) {
    fetchSavedUser();
  }
  final AuthRepository authRepository;

  Future<void> signInWithEmailAndPassword(AuthRequest authRequest) async {
    try {
      final userCredential = await authRepository.signInWithEmailAndPassword(
        authRequest,
      );
      emit(state.copyWith(
        exception: null,
        userCredential: userCredential,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(exception: e));
    }
  }

  Future<void> signUpWithEmailAndPassword(AuthRequest authRequest) async {
    try {
      await authRepository.signUpWithEmailAndPassword(
        authRequest,
      );
    } on Exception catch (e) {
      emit(state.copyWith(exception: e));
    }
  }

  Future<void> authenticateWithSocialLogin(
      SocialAuthentication socialAuthentication) {
    // TODO: implement authenticateWithSocialLogin
    throw UnimplementedError();
  }

  Future<void> deleteAccount() {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }

  Future<void> fetchSavedUser() async {
    try {
      final userCredential = await authRepository.fetchSavedUser();
      emit(state.copyWith(userCredential: userCredential));
    } catch (e) {
      emit(state.copyWith(userCredential: null));
    }
  }

  @override
  Future<void> fetchUser() async {
    try {
      final user = await authRepository.fetchUser();
      emit(state.copyWith(userCredential: null));
    } catch (e) {
      emit(state.copyWith(userCredential: null, exception: null));
    }
  }

  @override
  Future<void> forgotPassword({required String email}) =>
      authRepository.forgotPassword(email: email);

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> updateDeviceToken() {
    // TODO: implement updateDeviceToken
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserData(
    UserData userData,
  ) {
    // TODO: implement updateUserData
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserPassword(
      {required String currentPassword, required String newPassword}) {
    // TODO: implement updateUserPassword
    throw UnimplementedError();
  }
}
