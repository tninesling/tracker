FROM rust:1.57-buster as base
RUN cargo install cargo-chef
WORKDIR /app

FROM base as planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM base AS builder
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --recipe-path recipe.json
COPY . .
RUN cargo build --bin migrator

FROM debian:buster-slim AS runtime
COPY --from=builder /app/target/debug/migrator /usr/local/bin
ENTRYPOINT [ "/usr/local/bin/migrator" ]

EXPOSE 8080