mod models;
mod routes;

use crate::workouts::Workout;
use chrono::Timelike;
use std::collections::HashMap;

pub use models::*;
pub use routes::init;

pub fn condense_summaries_by_day(summaries: Vec<WorkoutSummary>) -> Vec<WorkoutSummary> {
    let mut running_totals = HashMap::with_capacity(summaries.len());
    for summary in summaries {
        if let Some(t) = running_totals.get_mut(&beginning_of_day(summary.date)) {
            *t += summary.total_weight_kg;
        } else {
            running_totals.insert(beginning_of_day(summary.date), summary.total_weight_kg);
        }
    }

    running_totals
        .drain()
        .map(|(date, total_weight_kg)| WorkoutSummary {
            date,
            total_weight_kg,
        })
        .collect()
}

pub fn summarize_workout(workout: &Workout) -> WorkoutSummary {
    WorkoutSummary {
        date: beginning_of_day(workout.date),
        total_weight_kg: workout
            .exercises
            .iter()
            .fold(0.0, |acc, e| acc + e.weight_kg),
    }
}

fn beginning_of_day<T: Timelike>(time_like: T) -> T {
    time_like
        .with_hour(0)
        .unwrap()
        .with_minute(0)
        .unwrap()
        .with_second(0)
        .unwrap()
        .with_nanosecond(0)
        .unwrap()
}
