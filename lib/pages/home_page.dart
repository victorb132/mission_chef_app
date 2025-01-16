import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mission_chef_app/components/popular_food_item.dart';
import 'package:mission_chef_app/controllers/auth_controller.dart';
import 'package:mission_chef_app/controllers/meal_controller.dart';
import 'package:mission_chef_app/models/meal_model.dart';
import 'package:mission_chef_app/utils/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthController authController = Get.find<AuthController>();
  final MealController mealController = Get.find<MealController>();
  final ScrollController _scrollController = ScrollController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  User? user;
  int _currentIndex = 0;
  int _selectedIndex = 0;

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

    if (mealController.meals.isEmpty) {
      mealController.fetchMeals();
    }
    getUser();

    // Configurar notificações locais
    _setupFlutterLocalNotifications();

    // Listener para notificações recebidas em primeiro plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          "Mensagem recebida em primeiro plano: ${message.notification?.title}");

      if (message.notification != null) {
        _showNotification(
          title: message.notification!.title ?? "Sem título",
          body: message.notification!.body ?? "Sem corpo",
        );
      }
    });

    // Listener para quando o app é aberto por uma notificação
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notificação clicada: ${message.notification?.title}");
    });
  }

  // Configurar notificações locais
  void _setupFlutterLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Exibir notificação local
  void _showNotification({required String title, required String body}) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'default_channel', // ID do canal
      'Notificações', // Nome do canal
      channelDescription: 'Canal de notificações padrão',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.show(
      0, // ID da notificação
      title,
      body,
      platformChannelSpecifics,
    );
  }

  List<MealModel> _getFilteredFoods() {
    if (_selectedIndex == 0) {
      return mealController.meals;
    }
    final selectedCategory = mealController.categories[_selectedIndex];
    return mealController.meals
        .where((item) => item.category == selectedCategory)
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
          child: Obx(() {
            if (mealController.isLoading.value) {
              return Center(
                child: Lottie.asset(
                  'assets/animations/loading.json',
                  height: 700,
                ),
              );
            }

            if (mealController.meals.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhuma receita encontrada.',
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 16,
                  ),
                ),
              );
            }

            return Column(
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
                      'Categorias',
                      style: TextStyle(
                        fontSize: 24,
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                _filterCategories(),
                const SizedBox(height: 16),
                _listFilteredFoods(filteredFoods),
              ],
            );
          }),
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
        itemCount: 3,
        itemBuilder: (context, index) {
          return PopularFoodItem(food: mealController.meals[index]);
        },
      ),
    );
  }

  Widget _dotsListPopularFood() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
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
            itemCount: mealController.categories.length,
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
                      mealController.categories[index],
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

  Widget _listFilteredFoods(List<MealModel> filteredFoods) {
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
      itemCount: filteredFoods.length,
      itemBuilder: (context, index) {
        final meal = filteredFoods[index];

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
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
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
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.terciaryText,
                                    ),
                                  ),
                                ],
                              ),
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
                    border: Border.all(color: Colors.white, width: 2), // Borda
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
  }
}
