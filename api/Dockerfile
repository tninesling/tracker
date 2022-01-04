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
RUN cargo build --bin api

FROM debian:buster-slim AS runtime
WORKDIR /app
COPY --from=builder /app/target/debug/api /usr/local/bin
ENTRYPOINT [ "/usr/local/bin/api" ]

EXPOSE 8080