use crate::trends::*;
use actix_web::{get, web, HttpResponse, Responder};

pub fn init(cfg: &mut web::ServiceConfig) {
  cfg
    .service(get_calorie_trend)
    .service(get_carbs_trend)
    .service(get_fat_trend)
    .service(get_protein_trend);
}

#[get("/trends/calories")]
async fn get_calorie_trend() -> impl Responder {
  let points = vec![
    Point {
      x: 1.0,
      y: 2100.0,
      label: "12/21".to_string(),
    },
    Point {
      x: 2.0,
      y: 1900.0,
      label: "12/22".to_string(),
    },
    Point {
      x: 3.0,
      y: 2080.0,
      label: "12/23".to_string(),
    },
    Point {
      x: 6.0,
      y: 1975.8,
      label: "12/26".to_string(),
    },
  ];

  let line = linear_regression(&points);

  HttpResponse::Ok().json(Trend { points, line })
}

#[get("/trends/carbohydrates")]
async fn get_carbs_trend() -> impl Responder {
  let points = vec![
    Point {
      x: 1.0,
      y: 210.0,
      label: "12/21".to_string(),
    },
    Point {
      x: 2.0,
      y: 190.0,
      label: "12/22".to_string(),
    },
    Point {
      x: 3.0,
      y: 208.0,
      label: "12/23".to_string(),
    },
    Point {
      x: 6.0,
      y: 195.8,
      label: "12/26".to_string(),
    },
  ];

  let line = linear_regression(&points);

  HttpResponse::Ok().json(Trend { points, line })
}

#[get("/trends/fat")]
async fn get_fat_trend() -> impl Responder {
  let points = vec![
    Point {
      x: 1.0,
      y: 85.0,
      label: "12/21".to_string(),
    },
    Point {
      x: 2.0,
      y: 93.0,
      label: "12/22".to_string(),
    },
    Point {
      x: 3.0,
      y: 80.0,
      label: "12/23".to_string(),
    },
    Point {
      x: 6.0,
      y: 75.8,
      label: "12/26".to_string(),
    },
  ];

  let line = linear_regression(&points);

  HttpResponse::Ok().json(Trend { points, line })
}

#[get("/trends/protein")]
async fn get_protein_trend() -> impl Responder {
  let points = vec![
    Point {
      x: 1.0,
      y: 120.0,
      label: "12/21".to_string(),
    },
    Point {
      x: 2.0,
      y: 190.0,
      label: "12/22".to_string(),
    },
    Point {
      x: 3.0,
      y: 108.0,
      label: "12/23".to_string(),
    },
    Point {
      x: 6.0,
      y: 175.8,
      label: "12/26".to_string(),
    },
  ];

  let line = linear_regression(&points);

  HttpResponse::Ok().json(Trend { points, line })
}
