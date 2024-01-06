import '../social_authentication/social_authentication.dart';
import 'models/m_auth_credential.dart';
import 'models/m_auth_request.dart';
import 'models/m_user.dart';

abstract class AuthRepository {
  Future<void> updateUserData(
    UserData userData,
  );
  Future<void> updateUserPassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<void> forgotPassword({
    required String email,
  });
  Future<void> logout();
  Future<void> updateDeviceToken();
  Future<UserCredential> signInWithEmailAndPassword(AuthRequest authRequest);
  Future<void> signUpWithEmailAndPassword(AuthRequest authRequest);
  Future<UserCredential> authenticateWithSocialLogin(
    SocialAuthentication socialAuthentication,
  );
  Future<void> deleteAccount();
  Future<UserCredential?> fetchSavedUser();
  Future<User?> fetchUser();
}
