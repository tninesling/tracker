import 'dart:collection';
import 'package:openapi/api.dart' as openapi;
import 'package:sqflite/sqflite.dart';
import 'package:ui/models/workout.dart';
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
  Future<Iterable<Meal>> getAllMeals(DateFilter dateFilter);
  Future<Iterable<Meal>> getFirstPageOfMeals(DateFilter dateFilter);
  Future<Iterable<Meal>> getNextPageOfMeals();
  Future<Iterable<Trend>> getMacroTrends(DateTime since);
  Future<Exercise> createExercise(CreateExerciseRequest req);
  Future<Iterable<Exercise>> getFirstPageOfExercises();
  Future<Iterable<Exercise>> getNextPageOfExercises();
  Future<Workout> createWorkout(CreateWorkoutRequest req);
  Future deleteWorkout(String workoutsId);
  Future<Iterable<Workout>> getAllWorkouts();
  Future<Iterable<Workout>> getFirstPageOfWorkouts();
  Future<Iterable<Workout>> getNextPageOfWorkouts();
}

mixin SyntacticSugar on Storage {
  @override
  Future<Iterable<Meal>> getAllMeals(DateFilter dateFilter) async {
    var allMealsLoaded = false;
    List<Meal> meals = (await getFirstPageOfMeals(dateFilter)).toList();

    while (!allMealsLoaded) {
      var nextPage = await getNextPageOfMeals();
      meals.addAll(nextPage);
      allMealsLoaded = nextPage.isEmpty;
    }

    return meals;
  }

  @override
  Future<Iterable<Workout>> getAllWorkouts() async {
    var allWorkoutsLoaded = false;
    List<Workout> workouts = (await getFirstPageOfWorkouts()).toList();

    while (!allWorkoutsLoaded) {
      var nextPage = await getNextPageOfWorkouts();
      workouts.addAll(nextPage);
      allWorkoutsLoaded = nextPage.isEmpty;
    }

    return workouts;
  }
}

class DateFilter {
  DateTime after;
  DateTime before;

  DateFilter({DateTime? after, DateTime? before})
      : after = after ?? DateTime.fromMillisecondsSinceEpoch(0),
        before = before ?? DateTime.now();
}

class LocalStorage extends Storage with SyntacticSugar {
  Database db;

  LocalStorage({required this.db});

  @override
  Future<Ingredient> createIngredient(CreateIngredientRequest req) async {
    var ingredient = Ingredient.fromCreateRequest(req);
    await db.insert('ingredients', ingredient.toMap());
    return ingredient;
  }

  var ingredientPageSize = 20;
  var nextIngredientOffset = 0;

  @override
  Future<Iterable<Ingredient>> getFirstPageOfIngredients() {
    nextIngredientOffset = 0;
    return getNextPageOfIngredients();
  }

  @override
  Future<Iterable<Ingredient>> getNextPageOfIngredients() async {
    var records = await db.query('ingredients',
        offset: nextIngredientOffset, limit: ingredientPageSize);
    nextIngredientOffset += ingredientPageSize;
    return records.map(Ingredient.fromMap);
  }

  @override
  Future<Meal> createMeal(CreateMealRequest req) async {
    var id = const Uuid().v4();
    await db.insert('meals', {'id': id, 'date': req.date.toIso8601String()});
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

  var mealPageSize = 20;
  var nextMealOffset = 0;
  var filter = DateFilter();

  @override
  Future<Iterable<Meal>> getFirstPageOfMeals(DateFilter dateFilter) {
    filter = dateFilter;
    nextMealOffset = 0;
    return getNextPageOfMeals();
  }

  @override
  Future<Iterable<Meal>> getNextPageOfMeals() async {
    var records = await db.rawQuery(Sqlite.selectMealsPageAndIngredients(), [
      filter.after.toIso8601String(),
      filter.before.toIso8601String(),
      mealPageSize,
      nextMealOffset
    ]);
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
    nextMealOffset += hm.values.length;

    return hm.values;
  }

  @override
  Future<Iterable<Trend>> getMacroTrends(DateTime after) async {
    var macroSummaries = await db.rawQuery(
        Sqlite.selectMacroSummariesAfterDate(), [after.toIso8601String()]);
    List<Point> carbPoints = [];
    List<Point> fatPoints = [];
    List<Point> proteinPoints = [];

    for (var s in macroSummaries) {
      var label = s['date'] as String;
      var date = DateTime.parse(s['date'] as String);
      var x = date.difference(after).inDays.toDouble();
      carbPoints.add(Point(label: label, x: x, y: s['carb_grams'] as double));
      fatPoints.add(Point(label: label, x: x, y: s['fat_grams'] as double));
      proteinPoints
          .add(Point(label: label, x: x, y: s['protein_grams'] as double));
    }

    return [
      Trend(
          name: "Carbohydrates (g)",
          points: carbPoints,
          line: Line.linearRegressionOf(carbPoints)),
      Trend(
          name: "Fat (g)",
          points: fatPoints,
          line: Line.linearRegressionOf(fatPoints)),
      Trend(
          name: "Protein (g)",
          points: proteinPoints,
          line: Line.linearRegressionOf(proteinPoints)),
    ];
  }

  @override
  Future<Workout> createWorkout(CreateWorkoutRequest req) async {
    var workoutsId = const Uuid().v4();
    // TODO: wrap in a transaction
    await db.insert(
        'workouts', {'id': workoutsId, 'date': req.date.toIso8601String()});

    for (var entry in req.exerciseAmounts.entries) {
      await db.insert('workouts_exercises', {
        'workouts_id': workoutsId,
        'exercises_id': entry.key,
        'amount': entry.value,
        'workout_order': req.exerciseOrder[entry.key],
      });
    }

    return (await getWorkoutById(workoutsId))!;
  }

  Future<Workout?> getWorkoutById(String id) async {
    var records =
        await db.rawQuery(Sqlite.selectWorkoutAndExercisesForWorkout(), [id]);

    Workout? workout;
    for (var r in records) {
      workout ??= Workout(
          id: r["workouts_id"] as String,
          date: DateTime.parse(r["date"] as String),
          exercises: []);
      workout.exercises.add(Exercise.fromMap(r));
    }

    return workout;
  }

  var workoutPageSize = 20;
  var nextWorkoutPageOffset = 0;

  @override
  Future<Iterable<Workout>> getFirstPageOfWorkouts() {
    nextWorkoutPageOffset = 0;
    return getNextPageOfWorkouts();
  }

  @override
  Future<Iterable<Workout>> getNextPageOfWorkouts() async {
    var records = await db.rawQuery(Sqlite.selectWorkoutsPageAndExercises(), [
      workoutPageSize,
      nextWorkoutPageOffset,
    ]);
    var hm = HashMap<String, Workout>();
    for (var r in records) {
      var workoutsId = r['workouts_id'] as String;
      hm[workoutsId] ??= Workout(
          id: workoutsId,
          date: DateTime.parse(r["date"] as String),
          exercises: []);
      hm[workoutsId]!.exercises.add(Exercise.fromMap(r));
    }
    nextWorkoutPageOffset += hm.values.length;

    return hm.values;
  }

  @override
  Future deleteWorkout(String workoutsId) async {
    await db.delete('workouts', where: 'id = ?', whereArgs: [workoutsId]);
  }

  @override
  Future<Exercise> createExercise(CreateExerciseRequest req) async {
    var id = const Uuid().v4();
    await db
        .insert('exercises', {'id': id, 'name': req.name, 'unit': req.unit});
    return Exercise.fromRequest(id, req);
  }

  var exercisePageSize = 20;
  var nextExerciseOffset = 0;

  @override
  Future<Iterable<Exercise>> getFirstPageOfExercises() {
    nextExerciseOffset = 0;
    return getNextPageOfExercises();
  }

  @override
  Future<Iterable<Exercise>> getNextPageOfExercises() async {
    var records = await db.query('exercises',
        limit: exercisePageSize, offset: nextExerciseOffset);
    nextExerciseOffset += exercisePageSize;
    return records.map(Exercise.fromMap);
  }
}

class RemoteStorage extends Storage with SyntacticSugar {
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
  Future<Iterable<Meal>> getFirstPageOfMeals(DateFilter dateFilter) async {
    try {
      // TODO: Incorporate before parameter from filter
      var page = await openapiClient.getMeals(
          after: dateFilter.after, limit: mealPageSize);
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

  @override
  Future<Iterable<Workout>> getFirstPageOfWorkouts() {
    // TODO: implement getFirstPageOfWorkouts
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Workout>> getNextPageOfWorkouts() {
    // TODO: implement getNextPageOfWorkouts
    throw UnimplementedError();
  }

  @override
  Future<Workout> createWorkout(CreateWorkoutRequest req) {
    // TODO: implement createWorkout
    throw UnimplementedError();
  }

  @override
  Future deleteWorkout(String workoutsId) {
    // TODO: implement deleteWorkout
    throw UnimplementedError();
  }

  @override
  Future<Exercise> createExercise(CreateExerciseRequest req) {
    // TODO: implement createExercise
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Exercise>> getFirstPageOfExercises() {
    // TODO: implement getFirstPageOfExercises
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Exercise>> getNextPageOfExercises() {
    // TODO: implement getNextPageOfExercises
    throw UnimplementedError();
  }
}
