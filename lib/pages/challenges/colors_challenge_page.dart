import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mission_chef_app/utils/app_colors.dart';

class ColorsChallengePage extends StatefulWidget {
  const ColorsChallengePage({super.key});

  @override
  State<ColorsChallengePage> createState() => _ColorsChallengePageState();
}

class _ColorsChallengePageState extends State<ColorsChallengePage>
    with SingleTickerProviderStateMixin {
  final Random _random = Random();
  List<Color> selectedColors = [];
  bool isLoading = false;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    selectedColors = _generateRandomColors();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void selectRandomColors() {
    setState(() {
      isLoading = true;
    });

    _animationController.reset();
    _animationController.forward().whenComplete(() {
      setState(() {
        selectedColors = _generateRandomColors();
        isLoading = false;
      });
    });
  }

  List<Color> _generateRandomColors() {
    return List.generate(3, (_) => _randomColor());
  }

  Color _randomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );
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
                const Text(
                  "Cores Aleatórias",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: selectedColors
                      .map((color) => Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          InkWell(
            onTap: selectRandomColors,
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
