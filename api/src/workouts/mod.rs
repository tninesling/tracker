mod models;
mod routes;

pub use models::*;
pub use routes::init;

pub fn next_workout(w: &Workout) -> WorkoutRequest {
    WorkoutRequest {
        date: w.date,
        exercises: w.exercises.iter().map(next_exercise).collect(),
    }
}

fn next_exercise(e: &Exercise) -> ExerciseRequest {
    let (sets, reps, weight_kg) = match (e.sets, e.reps, e.weight_kg) {
        (5, 3, w) => (3, 10, to_light(w)),
        (3, 10, w) => (5, 4, to_heavy(w)),
        (5, 4, w) => (4, 10, to_light(w)),
        (4, 10, w) => (5, 5, to_heavy(w)),
        (5, 5, w) => (5, 10, to_light(w)),
        (5, 10, w) => (5, 3, increase_weight(to_heavy(w))),
        (s, r, w) => (s, r, increase_weight(w)),
    };

    ExerciseRequest {
        name: e.name.to_string(),
        reps,
        sets,
        weight_kg,
    }
}

fn to_heavy(weight: f32) -> f32 {
    (weight / 0.6).round()
}

fn to_light(weight: f32) -> f32 {
    (weight * 0.6).round()
}

fn increase_weight(weight: f32) -> f32 {
    (weight * 1.05).round()
}
