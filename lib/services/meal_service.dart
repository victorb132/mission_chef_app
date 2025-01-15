import 'dart:convert';

import 'package:mission_chef_app/interfaces/meals_service_interface.dart';
import 'package:mission_chef_app/interfaces/request_service_interface.dart';
import 'package:mission_chef_app/models/meal_model.dart';

class MealService implements IMealsService {
  final IRequestService client;

  MealService({required this.client});

  @override
  Future<MealModel> getMeal(String id) {
    // TODO: implement getMeal
    throw UnimplementedError();
  }

  @override
  Future<List<MealModel>> getMeals() async {
    final response = await client.get(
      url: 'https://www.themealdb.com/api/json/v1/1/search.php?s=',
    );

    if (response.statusCode == 200) {
      final List<MealModel> meals = [];

      final body = jsonDecode(response.body);

      body['meals'].map((mealMap) {
        final MealModel meal = MealModel.fromMap(mealMap);
        meals.add(meal);
      }).toList();

      return meals;
    } else if (response.statusCode == 404) {
      throw Exception('A url informada não é válida');
    } else {
      throw Exception('Não foi possível carregar os produtos');
    }
  }
}
