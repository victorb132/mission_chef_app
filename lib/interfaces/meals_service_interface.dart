import 'package:mission_chef_app/models/meal_model.dart';

abstract class IMealsService {
  Future<List<MealModel>> getMeals();
  Future<MealModel> getMeal(String id);
}
