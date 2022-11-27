use server::create_server;

#[tokio::main]
async fn main() -> Result<(), String> {
    create_server().await?.start().await
}
