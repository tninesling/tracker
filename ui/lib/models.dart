class Workout {
  final String date;

  Workout({
    required this.date,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      date: json['date'],
    );
  }
}