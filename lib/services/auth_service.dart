import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mission_chef_app/interfaces/auth_service_interface.dart';

class AuthService implements IAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _auth.signInWithCredential(credential);
  }

  @override
  Future<void> registerWithEmail(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> loginWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  @override
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  @override
  Future<void> updateUserData(String field, String value) async {
    try {
      User? user = _auth.currentUser;

      if (user == null) {
        throw Exception("Usuário não logado");
      }

      if (field == "displayName") {
        await user.updateDisplayName(value);
      } else if (field == "email") {
        await user.verifyBeforeUpdateEmail(value);
      } else if (field == "photoURL") {
        await user.updatePhotoURL(value);
      } else {
        throw Exception("Campo inválido para atualização");
      }

      await user.reload();
    } catch (e) {
      throw Exception("Erro ao atualizar $field: $e");
    }
  }
}
