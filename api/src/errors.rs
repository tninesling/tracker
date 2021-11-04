use actix_web::HttpResponse;

pub enum Error {
    DBError(rusqlite::Error),
}

impl Into<HttpResponse> for Error {
    fn into(self) -> HttpResponse {
        match self {
            Error::DBError(e) => HttpResponse::UnprocessableEntity().body(format!("{}", e)),
        }
    }
}
