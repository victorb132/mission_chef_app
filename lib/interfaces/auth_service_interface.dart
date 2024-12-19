import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthService {
  Future<void> signInWithGoogle();
  Future<void> registerWithEmail(String email, String password);
  Future<void> loginWithEmail(String email, String password);
  Future<void> resetPassword(String email);
  Future<void> signOut();
  User? getCurrentUser();
}
