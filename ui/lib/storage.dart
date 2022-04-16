import 'dart:collection';

import 'package:openapi/api.dart' as openapi;
import 'package:sqflite/sqflite.dart';
import 'package:ui/models/meal.dart';
import 'package:ui/models/trend.dart';
import 'package:ui/sqlite.dart';
import 'package:uuid/uuid.dart';

abstract class Storage {
  Future<Ingredient> createIngredient(CreateIngredientRequest req);
  Future<Iterable<Ingredient>> getFirstPageOfIngredients();
  Future<Iterable<Ingredient>> getNextPageOfIngredients();
  Future<Meal> createMeal(CreateMealRequest req);
  Future deleteMeal(String mealsId);
  Future<Iterable<Meal>> getFirstPageOfMeals(DateTime after);
  Future<Iterable<Meal>> getNextPageOfMeals();
  Future<Iterable<Trend>> getMacroTrends(DateTime since);
}

class LocalStorage implements Storage {
  Database db;

  LocalStorage({required this.db});

  @override
  Future<Ingredient> createIngredient(CreateIngredientRequest req) async {
    var ingredient = Ingredient.fromCreateRequest(req);
    await db.insert('ingredients', ingredient.toMap());
    return ingredient;
  }

  @override
  Future<Iterable<Ingredient>> getFirstPageOfIngredients() async {
    var records = await db.query('ingredients');
    return records.map(Ingredient.fromMap);
  }

  @override
  Future<Iterable<Ingredient>> getNextPageOfIngredients() async {
    // TODO: Use offset/limit to paginate
    return [];
  }

  @override
  Future<Meal> createMeal(CreateMealRequest req) async {
    var id = const Uuid().v4();
    await db.insert(
        'meals', {'id': id, 'date': req.date.toUtc().toIso8601String()});
    for (var entry in req.ingredientAmounts.entries) {
      await db.insert('meals_ingredients', {
        'meals_id': id,
        'ingredients_id': entry.key,
        'amount_grams': entry.value
      });
    }

    return (await getMealById(id))!;
  }

  Future<Meal?> getMealById(String id) async {
    var records =
        await db.rawQuery(Sqlite.selectMealAndIngredientsForMeal(), [id]);

    Meal? meal;
    for (var r in records) {
      meal ??= Meal(
          id: r["meals_id"] as String,
          date: DateTime.parse(r["date"] as String),
          ingredients: []);
      meal.ingredients.add(Ingredient.fromMap(r));
    }

    return meal;
  }

  @override
  Future deleteMeal(String mealsId) async {
    await db.delete('meals', where: 'id = ?', whereArgs: [mealsId]);
  }

  @override
  Future<Iterable<Meal>> getFirstPageOfMeals(DateTime after) async {
    var records = await db.rawQuery(Sqlite.selectAllMealsAndIngredients());

    var hm = HashMap<String, Meal>();
    for (var r in records) {
      var mealsId = r["meals_id"] as String;
      if (!hm.containsKey(mealsId)) {
        hm[mealsId] = Meal(
            id: mealsId,
            date: DateTime.parse(r["date"] as String),
            ingredients: []);
      }

      hm[mealsId]!.ingredients.add(Ingredient.fromMap(r));
    }

    return hm.values;
  }

  @override
  Future<Iterable<Meal>> getNextPageOfMeals() async {
    // All meals are returned in the first page
    return [];
  }

  @override
  Future<Iterable<Trend>> getMacroTrends(DateTime since) async {
    // TODO: implement
    return [];
  }
}

class RemoteStorage implements Storage {
  final ingredientPageSize = 20;
  final mealPageSize = 20;
  final openapi.DefaultApi openapiClient;
  late String? nextIngredientsPageToken;
  late String? nextMealsPageToken;

  RemoteStorage({required this.openapiClient});

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
  Future deleteMeal(String mealsId) async {
    await openapiClient.deleteMeal(mealsId);
  }

  @override
  Future<Iterable<Trend>> getMacroTrends(DateTime since) async {
    var trends = await openapiClient.getMacroTrends(since);

    return trends.map(Trend.fromOpenapi);
  }

  @override
  Future<Iterable<Meal>> getFirstPageOfMeals(DateTime after) async {
    try {
      var page =
          await openapiClient.getMeals(after: after, limit: mealPageSize);
      nextMealsPageToken = page.nextPage;

      return page.items.map(Meal.fromOpenapi);
    } catch (e) {
      return [];
    }
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