use include_dir::{include_dir, Dir};
use tokio_postgres::{NoTls, Error};

static SQL_DIRECTORY: Dir = include_dir!("$CARGO_MANIFEST_DIR/sql");

#[tokio::main]
async fn main() -> Result<(), Error> {
    let (client, connection) =
        tokio_postgres::connect("host=cockroachdb-public port=26257 user=root dbname=heath", NoTls).await?;

    tokio::spawn(async move {
        if let Err(e) = connection.await {
            eprintln!("connection error: {}", e);
        }
    });

    for upscript in SQL_DIRECTORY.files() {
        client.execute(upscript.contents_utf8().unwrap(), &[]).await?;
    }

    Ok(())
}