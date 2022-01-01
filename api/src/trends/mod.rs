mod dtos;
mod routes;

pub use dtos::*;
pub use routes::init;

pub fn linear_regression(points: &Vec<Point>) -> Line {
  let sum_x = points.iter().fold(0.0, |acc, p| acc + p.x);
  let sum_y = points.iter().fold(0.0, |acc, p| acc + p.y);
  let sum_xx = points.iter().fold(0.0, |acc, p| acc + p.x.powf(2.0));
  // let sum_yy = points.iter().fold(0.0, |acc, p| acc + p.y.powf(2.0));
  let sum_xy = points.iter().fold(0.0, |acc, p| acc + p.x * p.y);
  let n = points.len() as f32;

  let slope = (n * sum_xy - sum_x * sum_y) / (n * sum_xx - sum_x.powf(2.0));
  let intercept = sum_y / n - slope / n * sum_x;

  Line { slope, intercept }
}

#[cfg(test)]
mod tests {
  use super::*;

  #[test]
  fn basic_linear_regression() {
    // Example from https://en.wikipedia.org/wiki/Simple_linear_regression (Numerical example section)
    let heights = vec![
      1.47, 1.50, 1.52, 1.55, 1.57, 1.60, 1.63, 1.65, 1.68, 1.70, 1.73, 1.75, 1.78, 1.80, 1.83,
    ];
    let masses = vec![
      52.21, 53.12, 54.48, 55.84, 57.20, 58.57, 59.93, 61.29, 63.11, 64.47, 66.28, 68.10, 69.92,
      72.19, 74.46,
    ];
    let points = heights
      .iter()
      .zip(masses)
      .map(|(h, m)| Point {
        x: *h,
        y: m,
        label: String::new(),
      })
      .collect();

    let regression_line = linear_regression(&points);

    let allowed_error = 0.01;
    let expected_slope = 61.272;
    let expected_intercept = -39.062;
    let slope_error = (regression_line.slope - expected_slope).abs();
    let intercept_error = (regression_line.intercept - expected_intercept).abs();
    assert!(slope_error < allowed_error);
    assert!(intercept_error < allowed_error);
  }
}
