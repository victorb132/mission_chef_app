import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:master_chef_app/interfaces/auth_service_interface.dart';
import 'package:master_chef_app/interfaces/user_service_interface.dart';
import 'package:master_chef_app/pages/home_page.dart';
import 'package:master_chef_app/pages/login_page.dart';

class AuthController extends GetxController {
  final IAuthService _authService;
  final IUserService _userService;

  Rx<User?> user = Rx<User?>(null);

  AuthController(this._authService, this._userService);

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_authService.getCurrentUser() != null
        ? Stream.value(_authService.getCurrentUser())
        : const Stream.empty());
    if (_authService.getCurrentUser() != null) {
      _userService.saveUserData(_authService.getCurrentUser()!);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await _authService.signInWithGoogle();
      if (_authService.getCurrentUser() != null) {
        await _userService.saveUserData(_authService.getCurrentUser()!);
      }
      Get.offAll(() => const HomePage());
    } catch (e) {
      Get.snackbar("Erro", "Falha no login: $e");
    }
  }

  Future<void> registerWithEmail(String email, String password) async {
    try {
      await _authService.registerWithEmail(email, password);
      if (_authService.getCurrentUser() != null) {
        await _userService.saveUserData(_authService.getCurrentUser()!);
      }
      Get.offAll(() => const HomePage());
    } catch (e) {
      Get.snackbar("Erro no Registro", e.toString());
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    try {
      await _authService.loginWithEmail(email, password);
      if (_authService.getCurrentUser() != null) {
        await _userService.saveUserData(_authService.getCurrentUser()!);
      }
      Get.offAll(() => const HomePage());
    } catch (e) {
      Get.snackbar("Erro no Login", e.toString());
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    Get.offAll(() => const LoginPage());
  }

  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
      Get.snackbar(
        "Email Enviado",
        "Verifique sua caixa de entrada para redefinir a senha.",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        "Erro",
        "Não foi possível enviar o email. Verifique se o email está correto.",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<Map<String, String?>> getUserData() async {
    return await _userService.getUserData();
  }
}
