use actix_web::HttpResponse;

pub enum Error {
    DBError(sqlx::Error),
    NotFound,
    UuidParseError(uuid::Error),
}

impl Into<HttpResponse> for Error {
    fn into(self) -> HttpResponse {
        match self {
            Error::DBError(e) => HttpResponse::UnprocessableEntity().body(format!("{}", e)),
            Error::NotFound => HttpResponse::NotFound().body(""),
            Error::UuidParseError(_) => HttpResponse::BadRequest().body("Could not parse uuid"),
        }
    }
}
