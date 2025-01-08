import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mission_chef_app/mock/food_data_mock.dart';
import 'package:mission_chef_app/utils/app_colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> filteredFoods = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredFoods = mockFood;
  }

  void _filterFoods(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredFoods = mockFood;
      });
    } else {
      setState(
        () {
          filteredFoods = mockFood
              .where(
                (item) => item["title"].toString().toLowerCase().contains(
                      query.toLowerCase(),
                    ),
              )
              .toList();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const Icon(Icons.search, color: AppColors.primaryText),
        title: TextField(
          controller: _searchController,
          onChanged: _filterFoods,
          decoration: const InputDecoration(
            hintText: "Buscar receitas...",
            hintStyle: TextStyle(color: AppColors.terciaryText),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: AppColors.primaryText, fontSize: 18),
        ),
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: filteredFoods.isEmpty
            ? const Center(
                child: Text(
                  "Nenhuma receita encontrada.",
                  style: TextStyle(color: AppColors.primaryText, fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: filteredFoods.length,
                itemBuilder: (context, index) {
                  final food = filteredFoods[index];
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
                          style: const TextStyle(color: AppColors.terciaryText),
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
