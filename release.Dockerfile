# OBVIOUSLY `latest` is probably not the right move for a "production" build,
# but... this is a template.
FROM node:latest AS ui

WORKDIR /opt/app

COPY assets/package.json /opt/app/package.json
COPY assets/package-lock.json /opt/app/package-lock.json

RUN npm install

COPY assets/tsconfig.json /opt/app/
COPY assets/postcss.config.js /opt/app/
COPY assets/tailwind.config.js /opt/app/
COPY assets/src/ /opt/app/src/

RUN npm run build

FROM elixir:1.12-alpine AS api

# RUN apk add git

WORKDIR /opt/app

RUN mix local.hex --force && \
    mix local.rebar --force

ENV MIX_ENV=prod
ENV DATABASE_URL=$DATABASE_URL
ENV SECRET_KEY_BASE=$SECRET_KEY_BASE

COPY mix.exs mix.lock /opt/app/
COPY config config

RUN mix do deps.get, deps.compile

COPY --from=ui /opt/app/dist priv/static/

RUN mix phx.digest

COPY lib/ /opt/app/lib/

RUN MIX_ENV=prod mix do compile, release

FROM alpine:latest

RUN apk add --no-cache openssl ncurses-libs libstdc++

WORKDIR /opt/app

COPY --from=api /opt/app/_build/prod/rel/phoenix_react/ /opt/app/

ENV HOME /opt/app

ARG SECRET_KEY_BASE
ARG DATABASE_URL

ENV SECRET_KEY_BASE $SECRET_KEY_BASE
ENV DATABASE_URL $DATABASE_URL

CMD ["/opt/app/bin/phoenix_react", "start"]
