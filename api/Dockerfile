FROM rust:1.57-buster as build
WORKDIR /app
COPY . .
RUN cargo build

FROM debian:buster
WORKDIR /app
COPY --from=build /app/target/debug .