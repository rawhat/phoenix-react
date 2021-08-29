FROM elixir:latest

WORKDIR /opt/app

RUN \
  apt update && \
  apt install -y curl inotify-tools && \
  curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
  apt install -y nodejs

COPY mix.exs .
COPY mix.lock .

RUN mix do local.hex --force, \
  local.rebar --force, \
  deps.update --all, \
  deps.get, \
  deps.compile

# ADD assets /opt/app/assets/
RUN mkdir /opt/app/assets
WORKDIR /opt/app/assets

ADD assets/package.json /opt/app/assets/package.json
ADD assets/package-lock.json /opt/app/assets/package-lock.json

RUN npm install

ADD assets/tsconfig.json /opt/app/assets/tsconfig.json
ADD assets/postcss.config.js /opt/app/assets/postcss.config.js
ADD assets/tailwind.config.js /opt/app/assets/tailwind.config.js
ADD assets/src/ /opt/app/assets/src/

WORKDIR /opt/app

COPY lib/ /opt/app/lib/

CMD ["mix", "phx.server"]
