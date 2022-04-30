class CreateWorkoutRequest {
  final DateTime date;
  final Iterable<CreateWorkoutItemRequest> items;

  CreateWorkoutRequest({required this.date, required this.items});
}

class CreateWorkoutItemRequest {
  String id;
  int order;
  String name;
  String unit;
  int amount;

  CreateWorkoutItemRequest(
      {required this.id,
      required this.order,
      required this.name,
      required this.unit,
      required this.amount});
}

class Workout {
  final String id;
  final DateTime date;
  final List<WorkoutItem> items;

  Workout({required this.id, required this.date, required this.items});
}

abstract class WorkoutItem {
  String id;
  int order;
  String name;

  WorkoutItem({required this.id, required this.order, required this.name});

  String unit();
  int amount();

  Map<String, dynamic> toMap() => {
        'id': id,
        'workout_order': order,
        'name': name,
        'unit': unit(),
        'amount': amount(),
      };

  factory WorkoutItem.fromRequest(String id, CreateWorkoutItemRequest req) {
    switch (req.unit) {
      case 'kg':
        return WeightedExercise(
            id: id,
            order: req.order,
            name: req.name,
            weight: Weight(kilograms: req.amount));
      case 's':
        return TimedExercise(
            id: id,
            order: req.order,
            name: req.name,
            duration: Duration(seconds: req.amount));
      default:
        throw UnsupportedError(
            "${req.unit} is not yet supported as a unit for exercises");
    }
  }
}

class WeightedExercise extends WorkoutItem {
  final Weight weight;

  WeightedExercise(
      {required String id,
      required int order,
      required String name,
      required this.weight})
      : super(id: id, order: order, name: name);

  @override
  String unit() => "kg";

  @override
  int amount() => weight.inKilograms();
}

class Weight {
  final int kilograms;

  Weight({required this.kilograms});

  int inKilograms() {
    return kilograms;
  }
}

class TimedExercise extends WorkoutItem {
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
  int amount() => duration.inSeconds;
}

class Rest extends TimedExercise {
  Rest({required String id, required int order, required Duration duration})
      : super(id: id, order: order, name: "Rest", duration: duration);
}
