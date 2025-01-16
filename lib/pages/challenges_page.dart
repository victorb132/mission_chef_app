import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mission_chef_app/pages/challenges/mystery_challenge_page.dart';
import 'package:mission_chef_app/utils/app_colors.dart';

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

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  int? expandedCardIndex;

  final List<Challenge> challenges = [
    Challenge(
      id: 2,
      title: "Desafio de Ingrediente Misterioso",
      description:
          "Receba um ingrediente aleatório do aplicativo e crie uma receita utilizando-o.",
      action: () {
        Get.toNamed('/mystery');
      },
    ),
    Challenge(
      id: 3,
      title: "Desafio das 3 Cores",
      description:
          "Crie um prato com apenas ingredientes de três cores escolhidas aleatoriamente pelo aplicativo.",
      action: () {
        Get.toNamed('/colors');
      },
    ),
    Challenge(
      id: 7,
      title: "Desafio dos países",
      description:
          "Crie um prato que misture os 2 países escolhidos aleatoriamente pelo aplicativo.",
      action: () {
        Get.toNamed('/countries');
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
        padding: const EdgeInsets.all(16.0),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final isExpanded = expandedCardIndex == index;
          final challenge = challenges[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                expandedCardIndex = isExpanded ? null : index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(bottom: 16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: _getCardColor(index),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    challenge.title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            challenge.description,
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          ElevatedButton(
                            onPressed: challenge.action,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black26,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: const Text(
                              "Ver Desafio",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getCardColor(int index) {
    final colors = [
      Colors.white,
      AppColors.accent,
    ];
    return colors[index % colors.length];
  }
}
