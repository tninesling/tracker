FROM rust:1.65-buster as base
RUN cargo install cargo-chef
WORKDIR /app

FROM base as planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM base AS builder
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --recipe-path recipe.json
COPY . .
RUN cargo build --bin seeder

FROM debian:buster-slim AS runtime
COPY --from=builder /app/target/debug/seeder /usr/local/bin
CMD [ "/usr/local/bin/seeder" ]