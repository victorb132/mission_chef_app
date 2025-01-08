import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:master_chef_app/controllers/auth_controller.dart';
import 'package:master_chef_app/interfaces/auth_service_interface.dart';
import 'package:master_chef_app/interfaces/user_service_interface.dart';
import 'package:master_chef_app/pages/challenges/mystery_challenge_page.dart';
import 'package:master_chef_app/pages/challenges_page.dart';
import 'package:master_chef_app/pages/favorites_page.dart';
import 'package:master_chef_app/pages/food_details_page.dart';
import 'package:master_chef_app/pages/home_page.dart';
import 'package:master_chef_app/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:master_chef_app/pages/navigation_page.dart';
import 'package:master_chef_app/pages/profile_page.dart';
import 'package:master_chef_app/pages/search_page.dart';
import 'package:master_chef_app/pages/timer_page.dart';
import 'package:master_chef_app/services/auth_service.dart';
import 'package:master_chef_app/services/user_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final IAuthService authService = AuthService();
    final IUserService userService = UserService();

    Get.put(AuthController(authService, userService));

    return GetMaterialApp(
      title: 'Master chef app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.black),
        ),
      ),
      initialRoute: '/navigation',
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/profile', page: () => const ProfilePage()),
        GetPage(name: '/search', page: () => const SearchPage()),
        GetPage(name: '/favorite', page: () => const FavoritesPage()),
        GetPage(name: '/challenges', page: () => const ChallengesPage()),
        GetPage(name: '/navigation', page: () => const NavigationPage()),
        GetPage(name: '/food-details', page: () => const FoodDetailsPage()),
        GetPage(name: '/timer', page: () => const TimerPage()),
        GetPage(name: '/mystery', page: () => const MysteryChallengePage()),
      ],
    );
  }
}
