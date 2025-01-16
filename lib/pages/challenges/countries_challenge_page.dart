import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mission_chef_app/mock/countries_data.dart';
import 'package:mission_chef_app/utils/app_colors.dart';

class CountriesChallengePage extends StatefulWidget {
  const CountriesChallengePage({super.key});

  @override
  State<CountriesChallengePage> createState() => _CountriesChallengePageState();
}

class _CountriesChallengePageState extends State<CountriesChallengePage>
    with SingleTickerProviderStateMixin {
  List<Map<String, String>> selectedCountries = [];
  bool isLoading = false;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    selectedCountries = _generateRandomCountries();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void selectRandomCountries() {
    setState(() {
      isLoading = true;
    });

    _animationController.reset();
    _animationController.forward().whenComplete(() {
      setState(() {
        selectedCountries = _generateRandomCountries();
        isLoading = false;
      });
    });
  }

  List<Map<String, String>> _generateRandomCountries() {
    final shuffled = countries..shuffle();
    return shuffled.take(2).toList();
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
                  "Países Aleatórios",
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
                  children: selectedCountries
                      .map((country) => Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  country["flag"]!,
                                  width: 100,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.flag,
                                      color: Colors.grey,
                                      size: 60,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                country["name"]!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                ),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          InkWell(
            onTap: selectRandomCountries,
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
