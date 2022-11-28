use clap::Parser;
use clap::Subcommand;
use domain::meals::Ingredient;
use domain::storage::Database;
use domain::storage::Postgres;
use sqlx::postgres::PgPoolOptions;

#[derive(Parser)]
struct Cli {
    #[command(subcommand)]
    resource: Resource
}

#[derive(Debug, Subcommand)]
enum Resource {
    #[command(subcommand)]
    Ingredients(CRUDAction),
    #[command(subcommand)]
    Meals(CRUDAction),
    #[command(subcommand)]
    Trends(Trends),
}

#[derive(Debug, Subcommand)]
enum CRUDAction {
    Create,
    List,
    Read,
    Delete,
}

#[derive(Debug, Subcommand)]
enum Trends {
    Macros {
        #[arg(long)]
        since: String
    },
}

#[tokio::main]
async fn main() -> Result<(), String> {
    let connection_uri = std::env::var("PG_CONNECTION_URI").unwrap();
    let db_pool = PgPoolOptions::new()
        .connect(&connection_uri)
        .await
        .map_err(|e| format!("{}", e))?;
    let db = Postgres::new(&db_pool);

    match Cli::parse() {
        Cli { resource: Resource::Ingredients(CRUDAction::List)} => {
            let mut previous_length = 0;
            let mut ingredients: Vec<Ingredient> = Vec::new();

            loop {
                let mut is = db.get_ingredients(&(ingredients.len() as i32), &1000).await.map_err(|e| format!("{:?}", e))?;
                ingredients.append(&mut is);
                if ingredients.len() == previous_length {
                    break;
                }

                previous_length = ingredients.len();
            }

            println!("{:#?}", ingredients);
        },
        Cli { resource: Resource::Trends(Trends::Macros { since }) } => {
            let since = fuzzydate::parse(&since)?
                .and_local_timezone(chrono::Local)
                .unwrap()
                .with_timezone(&chrono::Utc);
            let trends = domain::trends::get_daily_macro_trends_since_date(&db, since)
                .await
                .map_err(|e| format!("{:#?}", e))?;
            
            println!("{:#?}", trends);
        }
        _ => println!("Nope")
    }

    Ok(())
}
