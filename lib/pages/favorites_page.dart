import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:master_chef_app/mock/food_data_mock.dart';
import 'package:master_chef_app/utils/app_colors.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> get favoriteFoods =>
      mockFood.where((item) => item["isFavorite"] == true).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          "Favoritos",
          style: TextStyle(color: AppColors.primaryText),
        ),
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: favoriteFoods.isEmpty
            ? const Center(
                child: Text(
                  "Você ainda não tem favoritos.",
                  style: TextStyle(color: AppColors.primaryText, fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: favoriteFoods.length,
                itemBuilder: (context, index) {
                  final food = favoriteFoods[index];

                  return GestureDetector(
                    onTap: () {
                      Get.toNamed('/food-details', arguments: food);
                    },
                    child: Card(
                      color: AppColors.cardBackground,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            food["url"] ?? '',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          food["title"] ?? '',
                          style: const TextStyle(
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "Tempo: ${food["timer"]} • Nível: ${food["level"]}",
                          style: const TextStyle(
                            color: Color(0xFFABABAB),
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(
                              () {
                                food["isFavorite"] = false;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
