FROM elixir:latest

ARG PORT

RUN apt-get update && \
  apt-get install -y postgresql-client

WORKDIR /app
COPY . /app

RUN mix local.hex --force \
  && mix local.rebar --force \
  && mix deps.get

EXPOSE $PORT

CMD ["mix", "phx.server"]
