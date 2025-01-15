import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthService {
  Future<void> signInWithGoogle();
  Future<void> registerWithEmail(String email, String password, String name);
  Future<void> loginWithEmail(String email, String password);
  Future<void> resetPassword(String email);
  Future<void> signOut();
  Future<void> updateUserData(String field, String value);
  User? getCurrentUser();
}
