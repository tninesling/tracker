use dropshot::HttpError;

pub type Result<T> = std::result::Result<T, Error>;

#[derive(Debug)]
pub enum Error {
    BadRequest(String),
    DBError(sqlx::Error),
}

// TODO: Put behind a dropshot feature
impl From<Error> for HttpError {
    fn from(val: Error) -> Self {
        match val {
            Error::BadRequest(str) => HttpError::for_bad_request(None, str),
            Error::DBError(sqlx_error) => HttpError::for_internal_error(sqlx_error.to_string()),
        }
    }
}

impl From<sqlx::Error> for Error {
    fn from(val: sqlx::Error) -> Self {
        Error::DBError(val)
    }
}
