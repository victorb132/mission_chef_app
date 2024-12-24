import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

import 'package:master_chef_app/utils/app_colors.dart';

class MysteryChallengePage extends StatefulWidget {
  const MysteryChallengePage({super.key});

  @override
  State<MysteryChallengePage> createState() => _MysteryChallengePageState();
}

class _MysteryChallengePageState extends State<MysteryChallengePage> {
  final List<String> ingredients = [
    "Tomate",
    "Cebola",
    "Alho",
    "Frango",
    "Carne Moída",
    "Pimenta",
    "Queijo",
    "Cenoura",
    "Batata",
    "Espinafre",
  ];

  String? selectedIngredient;

  void selectRandomIngredient() {
    final random = Random();
    setState(() {
      selectedIngredient = ingredients[random.nextInt(ingredients.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Desafio de Ingrediente Misterioso",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Receba um ingrediente aleatório e crie uma receita com ele!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: selectRandomIngredient,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                "Gerar Ingrediente",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 32),
            if (selectedIngredient != null)
              Column(
                children: [
                  Text(
                    "Ingrediente: $selectedIngredient",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Get.snackbar(
                        "Desafio Iniciado!",
                        "Use o ingrediente $selectedIngredient para criar sua receita!",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.orange.shade100,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      "Iniciar Desafio",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
