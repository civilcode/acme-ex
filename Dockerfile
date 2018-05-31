### BUILD
FROM bitwalker/alpine-elixir-phoenix as builder
RUN mkdir /app

WORKDIR /app

ARG MIX_ENV
ENV MIX_ENV ${MIX_ENV}
RUN echo $MIX_ENV

# Umbrella
COPY mix.exs mix.lock ./
COPY config config

# Apps
COPY apps apps
RUN mix do deps.get, deps.compile

# Build assets in production mode:
WORKDIR /app/apps/magasin_web/assets
RUN npm install && ./node_modules/webpack/bin/webpack.js --mode production

WORKDIR /app/apps/magasin_web
RUN mix phx.digest

WORKDIR /app
COPY rel rel
RUN mix release --env=$MIX_ENV --verbose


### RELEASE
FROM alpine:3.6

# we need bash and openssl for Phoenix
RUN apk update \
    apk upgrade --no-cache && \
    apk add --no-cache bash openssl

# EXPOSE is not used by Heroku, it uses the PORT env var and expose the same value
EXPOSE 4000

ARG MIX_ENV
ENV PORT=4000 \
    REPLACE_OS_VARS=true \
    SHELL=/bin/bash

RUN mkdir /app
WORKDIR /app

COPY --from=builder /app/_build/$MIX_ENV/rel/magasin/releases/0.1.0/magasin.tar.gz .

RUN tar xzf magasin.tar.gz && rm magasin.tar.gz

RUN chown -R root ./releases
RUN ls /app/bin

USER root

CMD ["/app/bin/magasin", "foreground"]
