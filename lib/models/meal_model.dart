class MealModel {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;
  final String youtube;
  final String source;
  final List<String> ingredients;

  MealModel({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    required this.youtube,
    required this.source,
    required this.ingredients,
  });

  factory MealModel.fromMap(Map<String, dynamic> map) {
    return MealModel(
      id: map['idMeal'] ?? '',
      name: map['strMeal'] ?? '',
      category: map['strCategory'] ?? '',
      area: map['strArea'] ?? '',
      instructions: map['strInstructions'] ?? '',
      thumbnail: map['strMealThumb'] ?? '',
      youtube: map['strYoutube'] ?? '',
      source: map['strSource'] ?? '',
      ingredients: List<String>.generate(
        20,
        (index) => map['strIngredient${index + 1}'] ?? '',
      )..removeWhere((element) => element.isEmpty),
    );
  }
}
