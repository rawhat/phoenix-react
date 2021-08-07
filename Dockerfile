FROM elixir:latest

WORKDIR /opt/app

RUN apt update && apt install -y nodejs npm inotify-tools

ADD assets /opt/app/assets/

COPY mix.exs .
COPY mix.lock .

RUN mix do local.hex --force, \
  local.rebar --force, \
  deps.update --all, \
  deps.get, \
  deps.compile

CMD ["mix", "phx.server"]
