import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mission_chef_app/components/popular_food_item.dart';
import 'package:mission_chef_app/controllers/auth_controller.dart';
import 'package:mission_chef_app/controllers/meal_controller.dart';
import 'package:mission_chef_app/mock/food_data_mock.dart';
import 'package:mission_chef_app/utils/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthController authController = Get.find<AuthController>();
  final MealController mealController = Get.find();

  final popularFood =
      mockFood.where((element) => element["isPopular"]).toList();

  User? user;
  List<String> categories = ["Todos"];

  int _currentIndex = 0;
  int _selectedIndex = 0;

  final ScrollController _scrollController = ScrollController();

  void getUser() async {
    final response = FirebaseAuth.instance.currentUser;
    setState(() {
      user = response;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _initializeCategories();
    mealController.fetchMeals();
    getUser();
  }

  void _initializeCategories() {
    final uniqueCategories =
        mockFood.map((item) => item["category"] as String).toSet();
    setState(() {
      categories.addAll(uniqueCategories);
    });
  }

  List<Map<String, dynamic>> _getFilteredFoods() {
    if (_selectedIndex == 0) {
      return mockFood;
    }
    final selectedCategory = categories[_selectedIndex];
    return mockFood
        .where((item) => item["category"] == selectedCategory)
        .toList();
  }

  void _onScroll() {
    final double offset = _scrollController.offset;
    final int index = (offset / MediaQuery.of(context).size.width).round();
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredFoods = _getFilteredFoods();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        toolbarHeight: 24,
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _listPopularFood(),
              const SizedBox(height: 16),
              _dotsListPopularFood(),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chefes',
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.filter_alt_outlined, color: AppColors.primaryText),
                ],
              ),
              _filterCategories(),
              const SizedBox(height: 16),
              _listFilteredFoods(filteredFoods),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, ${user?.displayName ?? ''}',
              style: const TextStyle(
                fontSize: 24,
                color: AppColors.primaryText,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Pronto para cozinhar?',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.terciaryText,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Get.toNamed('/profile');
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(30),
            ),
            clipBehavior: Clip.hardEdge,
            child: user?.photoURL != null
                ? Image.network(
                    user?.photoURL ?? '',
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 32,
                  ),
          ),
        )
      ],
    );
  }

  Widget _listPopularFood() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: popularFood.length,
        itemBuilder: (context, index) {
          return PopularFoodItem(food: popularFood[index]);
        },
      ),
    );
  }

  Widget _dotsListPopularFood() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        popularFood.length,
        (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: _currentIndex == index ? 16 : 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: _currentIndex == index
                  ? AppColors.accent
                  : AppColors.secondaryText,
            ),
          );
        },
      ),
    );
  }

  Widget _filterCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.accent
                        : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _listFilteredFoods(List<Map<String, dynamic>> filteredFoods) {
    return Obx(() {
      if (mealController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (mealController.meals.isEmpty) {
        return const Center(
          child: Text(
            'Nenhum prato encontrado.',
            style: TextStyle(
              color: AppColors.secondaryText,
            ),
          ),
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 60, bottom: 30),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 80,
          childAspectRatio: 0.8,
        ),
        itemCount: mealController.meals.length,
        itemBuilder: (context, index) {
          final meal = mealController.meals[index];

          return GestureDetector(
            onTap: () {
              Get.toNamed('/food-details', arguments: meal);
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 48),
                        Text(
                          meal.name,
                          style: const TextStyle(
                            fontSize: 20,
                            color: AppColors.primaryText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: AppColors.accent,
                            ),
                            Icon(
                              Icons.star,
                              size: 16,
                              color: AppColors.accent,
                            ),
                            Icon(
                              Icons.star,
                              size: 16,
                              color: AppColors.accent,
                            ),
                            Icon(
                              Icons.star,
                              size: 16,
                              color: AppColors.accent,
                            ),
                            Icon(
                              Icons.star,
                              size: 16,
                              color: AppColors.accent,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    meal.id.toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.terciaryText,
                                    ),
                                  ),
                                  const Text(
                                    'Min',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.terciaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 20,
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: AppColors.terciaryText,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Nível',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.terciaryText,
                                    ),
                                  ),
                                  Text(
                                    meal.category,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.terciaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -50,
                  left: 32,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border:
                          Border.all(color: Colors.white, width: 2), // Borda
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                      meal.thumbnail,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
