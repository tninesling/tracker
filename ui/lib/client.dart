import 'package:openapi/api.dart' as openapi;
import 'package:ui/models/meal.dart';
import 'package:ui/models/trend.dart';

abstract class ApiClient {
  Future<Ingredient> createIngredient(CreateIngredientRequest req);
  Future<Iterable<Ingredient>> getFirstPageOfIngredients();
  Future<Iterable<Ingredient>> getNextPageOfIngredients();
  Future<Meal> createMeal(CreateMealRequest req);
  Future<Iterable<Meal>> getFirstPageOfMeals(DateTime after);
  Future<Iterable<Meal>> getNextPageOfMeals();
  Future<Iterable<Trend>> getMacroTrends(DateTime since);
}

class OpenapiClientAdapter implements ApiClient {
  final ingredientPageSize = 20;
  final mealPageSize = 20;
  final openapi.DefaultApi openapiClient;
  late String? nextIngredientsPageToken;
  late String? nextMealsPageToken;

  OpenapiClientAdapter({required this.openapiClient});

  @override
  Future<Iterable<Ingredient>> getFirstPageOfIngredients() async {
    var ingredientsPage =
        await openapiClient.getIngredients(limit: ingredientPageSize);

    nextIngredientsPageToken = ingredientsPage.nextPage;

    return ingredientsPage.items.map(Ingredient.fromOpenapi);
  }

  @override
  Future<Iterable<Ingredient>> getNextPageOfIngredients() async {
    if (nextIngredientsPageToken == null) {
      return List.empty();
    }

    var ingredientsPage = await openapiClient.getIngredients(
        limit: ingredientPageSize, pageToken: nextIngredientsPageToken);

    nextIngredientsPageToken = ingredientsPage.nextPage;

    return ingredientsPage.items.map(Ingredient.fromOpenapi);
  }

  @override
  Future<Ingredient> createIngredient(CreateIngredientRequest req) async {
    var ingredient = await openapiClient.createIngredient(req.toOpenapi());

    return Ingredient.fromOpenapi(ingredient);
  }

  @override
  Future<Meal> createMeal(CreateMealRequest req) async {
    var meal = await openapiClient.createMeal(req.toOpenapi());

    return Meal.fromOpenapi(meal);
  }

  @override
  Future<Iterable<Trend>> getMacroTrends(DateTime since) async {
    var trends = await openapiClient.getMacroTrends(since);

    return trends.map(Trend.fromOpenapi);
  }

  @override
  Future<Iterable<Meal>> getFirstPageOfMeals(DateTime after) async {
    var page = await openapiClient.getMeals(after: after, limit: mealPageSize);

    nextMealsPageToken = page.nextPage;

    return page.items.map(Meal.fromOpenapi);
  }

  @override
  Future<Iterable<Meal>> getNextPageOfMeals() async {
    if (nextMealsPageToken == null) {
      return List.empty();
    }

    var page = await openapiClient.getMeals(
        limit: mealPageSize, pageToken: nextMealsPageToken);

    nextMealsPageToken = page.nextPage;

    return page.items.map(Meal.fromOpenapi);
  }
}

ApiClient apiClient = OpenapiClientAdapter(
    openapiClient:
        openapi.DefaultApi(openapi.ApiClient(basePath: 'http://192.168.49.2')));
