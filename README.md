# Heath

Health without taking an L

## Architecture

![Architecture Diagram](./arch.drawio.svg)

## Features

Workouts:
- [_] Record & manage workouts
- [_] Show trend in total weight lifted in workouts over time
- [_] Recommend next workout based on previous workouts

Diet
- [_] Record & manage diet/groceries
- [_] Show trend in macros over time
- [_] Recommend target calories, macros, and micros for day
- [_] Recommend next meal based on previous meal

Weight
- [_] Record & manage weight
- [_] Show trend in weight over time

Sleep
- [_] Record & manage sleep/caffeine
- [_] Show sleep trends overlayed with caffeine intake

## Development

### Spinning up the project

- Start minikube with `minikube start`
- Build & deploy services with `skaffold dev -f infra/skaffold.yaml`
  - If this fails with a missing `CrdbCluster` message, `kubectl apply` the missing CockroachDB manifests
- Expose the ingress on localhost with `minikube tunnel` (required on MacOS, otherwise just send requests to `minikube ip`)

### Connecting to the DB

Open a shell with
```
kubectl run cockroachdb -it \
--image=cockroachdb/cockroach:v21.2.3 \
--rm \
--restart=Never \
-- sql \
--insecure \
--host=cockroachdb-public \
--database=heath
```

### Generating API clients

Run the Swagger codegen CLI in a Docker container with (swap in spec location and language)
```
docker run --rm -v $(pwd):/local swaggerapi/swagger-codegen-cli-v3 generate -i /local/spec.json -l dart -o /local/swagger/dart
```
Note: currently has issues connecting to the minikube ip address, so it needs to be done with a local file mounted in a volume

## References

- SQLx: https://github.com/launchbadge/sqlx
- Actix SQLx example: https://github.com/actix/examples/tree/master/database-interactions/sqlx-todo
