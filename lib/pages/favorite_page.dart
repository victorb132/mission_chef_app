import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      appBar: AppBar(
        title: const Text("Favoritos"),
        backgroundColor: const Color(0xFF212121),
      ),
      body: const Center(
        child: Text(
          "Página Favoritos",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
