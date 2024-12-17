import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtém a instância do AuthController
    final AuthController authController = Get.find<AuthController>();

    // Aguarda a inicialização do estado de autenticação
    Future.delayed(const Duration(seconds: 2), () {
      if (authController.user.value != null) {
        Get.offAllNamed('/home'); // Redireciona para Home se autenticado
      } else {
        Get.offAllNamed('/login'); // Redireciona para Login se não autenticado
      }
    });

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              "Carregando...",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
