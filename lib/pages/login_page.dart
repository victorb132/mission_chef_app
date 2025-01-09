import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mission_chef_app/controllers/auth_controller.dart';
import 'package:mission_chef_app/pages/forgot_password_page.dart';
import 'package:mission_chef_app/utils/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hasAccount = true;
  bool _isLoading = false;

  final AuthController authController = Get.find<AuthController>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void changeToLoginOrRegister() {
    setState(() {
      hasAccount = !hasAccount;
    });
  }

  void clearInputs() {
    _emailController.clear();
    _passwordController.clear();
  }

  void _handleLoginOrRegister() async {
    setState(() {
      _isLoading = true;
    });
    if (hasAccount) {
      await authController.loginWithEmail(
        _emailController.text,
        _passwordController.text,
      );
      setState(() {
        _isLoading = false;
      });
    } else {
      await authController.registerWithEmail(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  InputDecoration _textFieldDecoration({String labelText = ''}) {
    return InputDecoration(
      focusColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      labelText: labelText,
      labelStyle: const TextStyle(color: AppColors.accent),
      border: const OutlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            if (Get.previousRoute.isEmpty) {
              Get.offAllNamed(
                '/navigation',
              );
            } else {
              Get.back();
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 48),
                  if (!hasAccount) ...[
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      decoration: _textFieldDecoration(labelText: 'Nome'),
                      cursorColor: Colors.white,
                    ),
                    const SizedBox(height: 16),
                  ],
                  _buildTextFields(),
                  const SizedBox(height: 24),
                  _buildForgotPassword(),
                  const SizedBox(height: 24),
                  _buildContinueButton(),
                  const SizedBox(height: 32),
                  _buildDividerWithText(),
                  const SizedBox(height: 32),
                  _buildSocialLoginButtons(),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          hasAccount ? 'Entrar' : 'Crie uma conta',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              hasAccount ? 'Não tem uma conta?' : 'Já tem uma conta?',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: changeToLoginOrRegister,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.only(left: 4),
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                hasAccount ? 'Registrar' : 'Entrar',
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextFields() {
    return Column(
      children: [
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
          decoration: _textFieldDecoration(labelText: 'E-mail'),
          cursorColor: Colors.white,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
          decoration: _textFieldDecoration(labelText: 'Senha'),
          cursorColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Get.to(() => const ForgotPasswordPage()),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'Esqueceu a senha?',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: () {
        _handleLoginOrRegister();
        clearInputs();
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 1,
              ),
            )
          : Text(
              hasAccount ? 'Entrar' : 'Registrar',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
    );
  }

  Widget _buildDividerWithText() {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'ou faça login com',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Row(
      children: [
        _buildSocialButton(
          'assets/images/google.png',
          'Google',
          authController.signInWithGoogle,
        ),
      ],
    );
  }

  Widget _buildSocialButton(String asset, String text, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.black,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(asset, width: 24, height: 24),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
