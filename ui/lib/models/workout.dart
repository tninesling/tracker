class CreateWorkoutRequest {
  final DateTime date;
  final Map<String, double> exerciseAmounts;
  final Map<String, int> exerciseOrder;

  CreateWorkoutRequest(
      {required this.date,
      required this.exerciseAmounts,
      required this.exerciseOrder});
}

class CreateExerciseRequest {
  String name;
  String unit;

  CreateExerciseRequest({required this.name, required this.unit});
}

class Workout {
  final String id;
  final DateTime date;
  final List<Exercise> exercises;

  Workout({required this.id, required this.date, required this.exercises});
}

abstract class Exercise {
  String id;
  int order;
  String name;

  Exercise({required this.id, required this.order, required this.name});

  String unit();
  double amount();

  Map<String, dynamic> toMap() => {
        'id': id,
        'workout_order': order,
        'name': name,
        'unit': unit(),
        'amount': amount(),
      };

  factory Exercise.fromMap(Map<String, dynamic> map) {
    String id = map['id'];
    String name = map['name'];
    int order = map['workout_order'] ?? 0;
    String unit = map['unit'];
    int amount = map['amount']?.toInt() ?? 0;

    return ExerciseBuilder()
        .withId(id)
        .withName(name)
        .withOrder(order)
        .withUnit(unit)
        .withAmount(amount)
        .build();
  }

  factory Exercise.fromRequest(String id, CreateExerciseRequest req) =>
      ExerciseBuilder()
          .withId(id)
          .withName(req.name)
          .withOrder(0) // TODO make sure this gets overwritten
          .withUnit(req.unit)
          .withAmount(0)
          .build();
}

class WeightedExercise extends Exercise {
  final Weight weight;

  WeightedExercise(
      {required String id,
      required int order,
      required String name,
      required this.weight})
      : super(id: id, order: order, name: name);

  @override
  String unit() => "g";

  @override
  double amount() => weight.inGrams();
}

class Weight {
  final int kilograms;
  final int grams;

  Weight({this.kilograms = 0, this.grams = 0});

  double inKilograms() => kilograms + grams / 1000;

  double inGrams() => inKilograms() + 1000;
}

class TimedExercise extends Exercise {
  final Duration duration;

  TimedExercise(
      {required String id,
      required int order,
      required String name,
      required this.duration})
      : super(id: id, order: order, name: name);

  @override
  String unit() => "s";

  @override
  double amount() => duration.inSeconds.toDouble();
}

class Rest extends TimedExercise {
  Rest({required String id, required int order, required Duration duration})
      : super(id: id, order: order, name: "Rest", duration: duration);
}

class ExerciseBuilder {
  String? id;
  String? name;
  int? order;
  String? unit;
  int? amount;

  ExerciseBuilder withId(String id) {
    this.id = id;
    return this;
  }

  ExerciseBuilder withName(String name) {
    this.name = name;
    return this;
  }

  ExerciseBuilder withOrder(int order) {
    this.order = order;
    return this;
  }

  ExerciseBuilder withUnit(String unit) {
    this.unit = unit;
    return this;
  }

  ExerciseBuilder withAmount(int amount) {
    this.amount = amount;
    return this;
  }

  Exercise build() {
    // TODO: Validate the values
    switch (unit) {
      case 'g':
        return WeightedExercise(
            id: id!,
            order: order!,
            name: name!,
            weight: Weight(grams: amount!));
      case 's':
        return TimedExercise(
            id: id!,
            order: order!,
            name: name!,
            duration: Duration(seconds: amount!));
      default:
        throw UnsupportedError(
            "$unit is not yet supported as a unit for exercises");
    }
  }
}
