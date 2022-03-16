use crate::meals::models::Meal;
use crate::meals::models::NutritionFacts;
use good_lp::default_solver;
use good_lp::variable;
use good_lp::variables;
use good_lp::Expression;
use good_lp::Solution;
use good_lp::SolverModel;
use good_lp::Variable;
use good_lp::variable::ProblemVariables;

struct MealBasketProblem {
    vars: ProblemVariables,
    nutrition_targets: NutritionFacts,
    total_calories: Expression,
    total_carb_grams: Expression,
    total_fat_grams: Expression,
    total_protein_grams: Expression,
}

impl MealBasketProblem {
    fn new(nutrition_targets: NutritionFacts) -> MealBasketProblem {
        MealBasketProblem {
            vars: variables!(),
            nutrition_targets,
            total_calories: 0.into(),
            total_carb_grams: 0.into(),
            total_fat_grams: 0.into(),
            total_protein_grams: 0.into(),
        }
    }

    fn add(&mut self, meal: &Meal) -> Variable {
        let amount_to_eat = self.vars.add(variable().min(0));
        self.total_calories += amount_to_eat * meal.calories();
        self.total_carb_grams += amount_to_eat * meal.carb_grams();
        self.total_fat_grams += amount_to_eat * meal.fat_grams();
        self.total_protein_grams += amount_to_eat * meal.protein_grams();
        amount_to_eat
    }

    fn best_quantities(self) -> impl Solution {
        let objective = self.total_calories.clone()
            + self.total_carb_grams.clone()
            + self.total_fat_grams.clone()
            + self.total_protein_grams.clone();

        self.vars
            .minimise(objective)
            .using(default_solver)
            .with(self.total_calories.geq(self.nutrition_targets.calories))
            .with(self.total_carb_grams.geq(self.nutrition_targets.carb_grams))
            .with(self.total_fat_grams.geq(self.nutrition_targets.fat_grams))
            .with(self.total_protein_grams.geq(self.nutrition_targets.protein_grams))
            .solve()
            .unwrap()
    }
}

#[cfg(test)]
mod tests {
    use crate::meals::models::Ingredient;
    use chrono::Utc;
    use uuid::Uuid;
    use super::*;

    #[test]
    fn sample() {
        let calorie_only_meal = Meal::builder()
            .id(Uuid::new_v4())
            .date(Utc::now())
            .ingredients(vec![
                Ingredient::builder()
                    .id(Uuid::new_v4())
                    .name("Calorie only".to_string())
                    .amount_grams(10.0)
                    .calories(10.0)
                    .carb_grams(0.0)
                    .fat_grams(0.0)
                    .protein_grams(0.0)
                    .build()
            ])
            .build();
        let carb_only_meal = Meal::builder()
            .id(Uuid::new_v4())
            .date(Utc::now())
            .ingredients(vec![
                Ingredient::builder()
                    .id(Uuid::new_v4())
                    .name("Carb only".to_string())
                    .amount_grams(10.0)
                    .calories(0.0)
                    .carb_grams(10.0)
                    .fat_grams(0.0)
                    .protein_grams(0.0)
                    .build()
            ])
            .build();
        let fat_only_meal = Meal::builder()
            .id(Uuid::new_v4())
            .date(Utc::now())
            .ingredients(vec![
                Ingredient::builder()
                    .id(Uuid::new_v4())
                    .name("Fat only".to_string())
                    .amount_grams(10.0)
                    .calories(0.0)
                    .carb_grams(0.0)
                    .fat_grams(10.0)
                    .protein_grams(0.0)
                    .build()
            ])
            .build();
        let protein_only_meal = Meal::builder()
            .id(Uuid::new_v4())
            .date(Utc::now())
            .ingredients(vec![
                Ingredient::builder()
                    .id(Uuid::new_v4())
                    .name("Protein only".to_string())
                    .amount_grams(10.0)
                    .calories(0.0)
                    .carb_grams(0.0)
                    .fat_grams(0.0)
                    .protein_grams(10.0)
                    .build()
            ])
            .build();
        let targets = NutritionFacts {
            amount_grams: 10.0,
            calories: 100.0,
            carb_grams: 10.0,
            fat_grams: 20.0,
            protein_grams: 30.0,
        };
        
        let mut solver = MealBasketProblem::new(targets);
        let calorie_only_meal = solver.add(&calorie_only_meal);
        let carb_only_meal = solver.add(&carb_only_meal);
        let fat_only_meal = solver.add(&fat_only_meal);
        let protein_only_meal = solver.add(&protein_only_meal);
        let solution = solver.best_quantities();

        let calorie_only_meal_servings = solution.value(calorie_only_meal);
        let carb_only_meal_servings = solution.value(carb_only_meal);
        let fat_only_meal_servings = solution.value(fat_only_meal);
        let protein_only_meal_servings = solution.value(protein_only_meal);

        assert_eq!(calorie_only_meal_servings, 10.0);
        assert_eq!(carb_only_meal_servings, 1.0);
        assert_eq!(fat_only_meal_servings, 2.0);
        assert_eq!(protein_only_meal_servings, 3.0);
    }
}