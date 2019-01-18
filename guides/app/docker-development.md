# Using Docker for a local development environment

## Running Tests

    docker-compose exec -e MIX_ENV=test application mix ecto.create
    docker-compose exec application mix test

## Helpful Commands

    docker-compose build
    docker-compose up -d
    docker-compose exec application mix ecto.create
    docker-compose exec application mix test
    docker-compose exec application mix test.watch
    docker-compose exec application mix ecto.rollback
    docker-compose exec application zsh    
    docker-compose exec application iex -S mix
    docker-compose exec application mix cmd --app child-app mix test.watch

## Using Observer

On MacOS, you first have to install XQuartz:

    brew cask install xquartz

Then, start XQuartz and change the following Security preferences:

- Authenticate connections: unchecked
- Allow connections from network clients: checked

Restart XQuartz for the new settings to be applied.

Using `observer` on the application node involves first starting the application
with a cookie and a short name. Then, you start an `observer` in the `erlang`
container using the same cookie, and then connect to the application node.

Start the application:

    make console

Start the observer:

    make observer

Connect to the application node in `observer` using the name `vm@application`.
