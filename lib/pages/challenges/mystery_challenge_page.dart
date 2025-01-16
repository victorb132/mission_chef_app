import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mission_chef_app/controllers/meal_controller.dart';
import 'dart:math';

import 'package:mission_chef_app/utils/app_colors.dart';

class MysteryChallengePage extends StatefulWidget {
  const MysteryChallengePage({super.key});

  @override
  State<MysteryChallengePage> createState() => _MysteryChallengePageState();
}

class _MysteryChallengePageState extends State<MysteryChallengePage>
    with SingleTickerProviderStateMixin {
  String? selectedIngredient;
  bool isLoading = false;

  final MealController mealController = Get.find();

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    if (mealController.ingredients.isEmpty) {
      mealController.fetchAllIngredients();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void selectRandomIngredient() {
    setState(() {
      isLoading = true;
    });

    _animationController.reset();
    _animationController.forward().whenComplete(() {
      final random = Random();
      setState(() {
        selectedIngredient = mealController
            .ingredients[random.nextInt(mealController.ingredients.length)];
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60),
              ),
            ),
            height: 400,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  selectedIngredient ?? "Clique na colher para sortear",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16.0),
                selectedIngredient != null
                    ? Expanded(
                        child: Image.network(
                          height: 200,
                          'https://www.themealdb.com/images/ingredients/$selectedIngredient.png',
                          fit: BoxFit.contain,
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          InkWell(
            onTap: selectRandomIngredient,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Lottie.asset(
              repeat: false,
              animate: isLoading,
              'assets/animations/loading.json',
              height: 300,
              width: 300,
              controller: _animationController,
            ),
          ),
        ],
      ),
    );
  }
}
