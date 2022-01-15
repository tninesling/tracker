use dropshot::HttpError;

pub type Result<T> = std::result::Result<T, Error>;

pub enum Error {
    DBError(sqlx::Error),
}

impl From<Error> for HttpError {
    fn from(val: Error) -> Self {
        match val {
            Error::DBError(sqlx_error) => HttpError::for_internal_error(sqlx_error.to_string()),
        }
    }
}
