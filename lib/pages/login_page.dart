import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hasAccount = true;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        print('Nome do Usuário: ${account.displayName}');
        print('Email: ${account.email}');
        print('Photo URL: ${account.photoUrl}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login bem-sucedido: ${account.displayName}'),
          ),
        );
      }
    } catch (error) {
      print('Erro no login com Google: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Falha no login com Google: $error'),
        ),
      );
    }
  }

  void changeToLoginOrRegister() {
    setState(() {
      hasAccount = !hasAccount;
    });
  }

  InputDecoration _textFieldDecoration({String labelText = ''}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      labelText: labelText,
      border: const OutlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 48),
                _buildHeader(),
                const SizedBox(height: 48),
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
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          hasAccount ? 'Entrar' : 'Crie uma conta',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              hasAccount ? 'Não tem uma conta?' : 'Já tem uma conta?',
              style: const TextStyle(fontSize: 14),
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
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
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
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(fontSize: 14),
          decoration: _textFieldDecoration(labelText: 'E-mail'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          obscureText: true,
          style: const TextStyle(fontSize: 14),
          decoration: _textFieldDecoration(labelText: 'Senha'),
        ),
      ],
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'Esqueceu a senha?',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      child: const Text(
        'Continuar',
        style: TextStyle(fontSize: 16, color: Colors.white),
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
          child: Text('ou faça login com', style: TextStyle(fontSize: 14)),
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
        _buildSocialButton('assets/images/apple.png', 'Apple', () {}),
        const SizedBox(width: 16),
        _buildSocialButton(
            'assets/images/google.png', 'Google', _handleGoogleSignIn),
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
