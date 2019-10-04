### BUILD STAGE
FROM bitwalker/alpine-elixir-phoenix:1.9.1 as builder
RUN mkdir /app

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

# Provide a default for the MIX_ENV, see heroku.yml for more information
ARG MIX_ENV=staging
ENV MIX_ENV ${MIX_ENV}
RUN echo $MIX_ENV

# Provide the release tag
ARG RELEASE_TAG
ENV RELEASE_TAG ${RELEASE_TAG}
RUN echo $RELEASE_TAG

# Copy relevant files
COPY mix.exs mix.lock ./
COPY config config
COPY rel rel
COPY README.md README.md
COPY apps apps

# All COPY operations from the host have been completed
RUN echo "It is now safe to switch branches."

# Get and compile deps
RUN mix do deps.get, deps.compile

# Compile docs
RUN mix docs
RUN mkdir -p apps/magasin_web/priv/static
RUN cp -r doc apps/magasin_web/priv/static/.

# Build assets in production mode:
WORKDIR /app/apps/magasin_web/assets

RUN npm install && ./node_modules/webpack/bin/webpack.js --mode production

WORKDIR /app/apps/magasin_web
RUN mix phx.digest

WORKDIR /app
RUN mix release acme_platform_$MIX_ENV

### RELEASE STAGE
FROM alpine:3.9

# we need bash and openssl for Phoenix, and curl for heroku
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache bash openssl curl

# install Postgresql (for demo data seeding)
RUN apk add --no-cache --virtual .build-deps \
  postgresql-client

# EXPOSE is not used by Heroku, it uses the PORT env var and expose the same value
EXPOSE 4000

# Provide a default for the MIX_ENV, see heroku.yml for more information
ARG MIX_ENV=staging
ENV PORT=4000 \
    SHELL=/bin/bash

RUN mkdir /app
WORKDIR /app


COPY --from=builder /app/_build/$MIX_ENV/rel/acme_platform_$MIX_ENV/ .
COPY --from=builder /app/rel/config/runtime.exs /etc
COPY --from=builder /app/rel/config/$MIX_ENV/*.exs /etc

RUN ln -s /app/bin/acme_platform_$MIX_ENV /app/bin/acme_platform

RUN chown -R root ./releases
RUN ls /app/bin

USER root

CMD ["/app/bin/acme_platform", "start"]
