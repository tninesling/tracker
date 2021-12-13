# Heath

Health without taking an l
## Features

### Workouts

- Exercise CRUD
  - Support weight in both lbs & kg

- Workout CRUD
  - Recording should allow setting date (i.e. record this workout from yesterday)
  - Deleting will require an identifier (uuid)

- Summarize workouts
  - Total weight per day

### Diet

- Ingredients & Meal CRUD
  - Calories, Macros & Micros
  - Amounts (mg, ml)

- Summarize diet
  - Today's macros/micros
  - Total macros/micros per day

- Recommend 1 week of meals
  - Generate grocery list

## References

- SQLx: https://github.com/launchbadge/sqlx
- Actix SQLx example: https://github.com/actix/examples/tree/master/database_interactions/sqlx_todo