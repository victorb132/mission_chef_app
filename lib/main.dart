import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:master_chef_app/controllers/auth_controller.dart';
import 'package:master_chef_app/pages/challenges_page.dart';
import 'package:master_chef_app/pages/favorite_page.dart';
import 'package:master_chef_app/pages/food_details_page.dart';
import 'package:master_chef_app/pages/home_page.dart';
import 'package:master_chef_app/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:master_chef_app/pages/navigation_page.dart';
import 'package:master_chef_app/pages/profile_page.dart';
import 'package:master_chef_app/pages/search_page.dart';
import 'package:master_chef_app/pages/splash_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPaintSizeEnabled = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());

    return GetMaterialApp(
      title: 'Master chef app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.black),
        ),
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashPage()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/profile', page: () => const ProfilePage()),
        GetPage(name: '/search', page: () => const SearchPage()),
        GetPage(name: '/favorite', page: () => const FavoritePage()),
        GetPage(name: '/challenges', page: () => const ChallengesPage()),
        GetPage(name: '/navigation', page: () => const NavigationPage()),
        GetPage(name: '/food-details', page: () => const FoodDetailsPage()),
      ],
    );
  }
}
