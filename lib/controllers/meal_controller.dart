import 'package:get/get.dart';
import 'package:mission_chef_app/models/meal_model.dart';
import 'package:mission_chef_app/services/meal_service.dart';

class MealController extends GetxController {
  final MealService mealService;

  MealController({required this.mealService});

  var meals = <MealModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchMeals() async {
    try {
      isLoading(true);
      final response = await mealService.getMeals();
      meals.value = response;
    } catch (e) {
      Get.snackbar('Erro', 'Falha ao carregar as refeições: $e');
    } finally {
      isLoading(false);
    }
  }
}
