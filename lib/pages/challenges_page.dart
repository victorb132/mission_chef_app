import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:master_chef_app/pages/challenges/mystery_challenge_page.dart';
import 'package:master_chef_app/utils/app_colors.dart';

class Challenge {
  final int id;
  final String title;
  final String description;
  final Function() action;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.action,
  });
}

class ChallengesPage extends StatelessWidget {
  ChallengesPage({super.key});

  final List<Challenge> challenges = [
    Challenge(
      id: 2,
      title: "Desafio de Ingrediente Misterioso",
      description:
          "Receba um ingrediente aleatório do aplicativo e crie uma receita utilizando-o.",
      action: () {
        Get.to(() => const MysteryChallengePage());
      },
    ),
    Challenge(
      id: 3,
      title: "Desafio das 3 Cores",
      description:
          "Crie um prato com apenas ingredientes de três cores escolhidas aleatoriamente pelo aplicativo.",
      action: () {
        Get.to(() => const MysteryChallengePage());
      },
    ),
    Challenge(
      id: 6,
      title: "Desafio do Temporizador",
      description:
          "Prepare uma receita selecionada dentro de um tempo limite usando o temporizador integrado.",
      action: () {
        Get.to(() => const MysteryChallengePage());
      },
    ),
    Challenge(
      id: 7,
      title: "Desafio Mundial",
      description:
          "Experimente cozinhar pratos de 5 diferentes culturas culinárias e compartilhe sua experiência.",
      action: () {
        Get.to(() => const MysteryChallengePage());
      },
    ),
    Challenge(
      id: 9,
      title: "Desafio de Duplas",
      description:
          "Cozinhe com um amigo ou familiar, compartilhando as responsabilidades do prato.",
      action: () {
        Get.to(() => const MysteryChallengePage());
      },
    ),
    Challenge(
      id: 10,
      title: "Desafio do Mês Temático",
      description:
          "Cozinhe receitas baseadas no tema do mês e envie fotos e comentários.",
      action: () {
        Get.to(() => const MysteryChallengePage());
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Desafios", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final challenge = challenges[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                challenge.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                challenge.description,
                style: const TextStyle(fontSize: 14),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.orange),
                onPressed: () => challenge.action(),
              ),
            ),
          );
        },
      ),
    );
  }
}
