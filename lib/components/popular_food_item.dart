import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mission_chef_app/models/meal_model.dart';
import 'package:mission_chef_app/utils/app_colors.dart';

class PopularFoodItem extends StatelessWidget {
  final MealModel food;

  const PopularFoodItem({required this.food, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/food-details', arguments: food);
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 36,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 16,
            left: 16,
            right: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Para Janta',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.name,
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            size: 16,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            food.id,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.terciaryText,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.filter_drama_rounded,
                            size: 16,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            food.category,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.terciaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  food.thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
