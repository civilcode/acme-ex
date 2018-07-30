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
