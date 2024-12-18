import 'package:flutter/material.dart';

class ChallengesPage extends StatelessWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      appBar: AppBar(
        title: const Text("Desafios"),
        backgroundColor: const Color(0xFF212121),
      ),
      body: const Center(
        child: Text(
          "Página Desafios",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
