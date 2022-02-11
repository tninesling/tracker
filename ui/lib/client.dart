import 'dart:collection';
import 'package:openapi/api.dart' as openapi;
import 'package:ui/models/meal.dart';
import 'package:ui/models/trend.dart';

abstract class ApiClient {
  Future<Iterable<Ingredient>> getFirstPageOfIngredients();
  Future<Iterable<Ingredient>> getNextPageOfIngredients();
  Future<Ingredient> createIngredient(CreateIngredientRequest req);
  Future<Meal> createMeal(CreateMealRequest req);
  Future<Iterable<Trend>> getMacroTrends(DateTime since);
}

class OpenapiClientAdapter implements ApiClient {
  final ingredientPageSize = 20;
  final openapi.DefaultApi openapiClient;
  late String? nextIngredientsPageToken;

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
}

ApiClient apiClient = OpenapiClientAdapter(
    openapiClient:
        openapi.DefaultApi(openapi.ApiClient(basePath: 'http://192.168.49.2')));
