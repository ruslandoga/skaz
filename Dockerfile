FROM hexpm/elixir:1.14.5-erlang-26.0-alpine-3.18.0 as builder

# install build dependencies
RUN apk add --no-cache --update git build-base nodejs npm

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
  mix local.rebar --force

# set build ENV
ENV MIX_ENV="prod"

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

# compile project
COPY priv priv
COPY lib lib
RUN mix do compile, deps.compile sentry --force

# compile assets
COPY assets assets
RUN mix assets.deploy

# Compile the release
COPY config/runtime.exs config/
COPY rel rel
RUN mix release

FROM litestream/litestream:0.3.9 AS litestream

FROM alpine:3.18.2

RUN apk add --no-cache --update openssl libstdc++ ncurses

WORKDIR "/app"

ENV MIX_ENV="prod"
COPY --from=builder /app/_build/${MIX_ENV}/rel/skaz ./
COPY --from=litestream /usr/local/bin/litestream /usr/local/bin/litestream
COPY litestream.yml /etc/litestream.yml

RUN adduser -H -S -u 999 -G nogroup -g '' skaz
USER 999

CMD litestream restore -if-db-not-exists -if-replica-exists $DATABASE_PATH && litestream replicate -exec "/app/bin/server"
