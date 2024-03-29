use include_dir::{include_dir, Dir};
use tokio_postgres::{Error, NoTls};

static SQL_DIRECTORY: Dir = include_dir!("$CARGO_MANIFEST_DIR/sql");

#[tokio::main]
async fn main() -> Result<(), Error> {
    let connection_uri = std::env::var("PG_CONNECTION_URI").unwrap();
    let (client, connection) = tokio_postgres::connect(
        &connection_uri,
        NoTls,
    )
    .await?;

    tokio::spawn(async move {
        if let Err(e) = connection.await {
            eprintln!("connection error: {}", e);
        }
    });

    for upscript in SQL_DIRECTORY.files() {
        for statement in upscript.contents_utf8().unwrap().split(";") {
            client.execute(statement, &[]).await?;
        }
    }

    Ok(())
}
