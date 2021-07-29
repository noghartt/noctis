# Noctis (Desafio Comadre)

## How to run

**ATTENTION:** In this project we use Docker to help run it in a development environment, you can run it outside of Docker if you wish.

### Copying environment variables

Copy `.env.sample` to `.env` and fill with necessary data. You may need to generate a secret to Guardian, you can see how do this [here](#how-can-i-generate-guardian-secret).
```
cp .env.sample .env
```

### Run inside Docker

You can run the container simply by running the command

```
docker-compose up --build
```

### Run outside of Docker

Outside of Docker, you need to run this commands:

Forcing fetch of install Hex locally, if necessary:

```
mix local.hex
```

Forcing fetch of a copy of `rebar` locally, if necessary:

```
mix local.rebar --force
```

Fetching all dependencies of the project
```
mix deps.get
```

Running project
```
mix phx.server
```

**HINT:** You can bypass a lot of instructions simple by using `mix setup` task.

### Setting up the database

You can create database with this command

**If you are inside Docker**
```
docker exec api mix ecto.create
```

**If you are outside of Docker**
```
mix ecto.create
```

### Run migrations to upsert tables on database

You can execute *migrations* with this command:

```
docker exec api mix ecto.migrate
```

If you run outside of docker, you can remove `docker exec api` command.

### Finally

You can access `GraphiQL` via `localhost:<port>/api/graphiql` to execute queries and migrations and view the API's schema.

## FAQ

### How can I generate Guardian secret?

If you run the project inside Docker, you can run
```
docker exec api mix guardian.gen.secret
```
to generate a secret and add to `GUARDIAN_SECRET` environment variable.

### How can I create a table on Database

If you run the project inside Docker, you can run
```
docker exec api mix ecto.create
```

Outside of Docker, you need to remove `docker exec api` and run the rest of the command.

### What are the endpoints of this API?

The endpoints are:
- `/api/graphql`: in prod, you can access the API via this endpoint
- `/api/graphiql`: **only dev environment**, you can access a playground to view schema, run queries and migrations, etc.
