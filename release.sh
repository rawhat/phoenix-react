#!/bin/sh
set -e

stty -echo
printf "DB Password: "
read DB_PASS
stty echo
printf "\n"

if [ -z $SECRET_KEY ]; then
  SECRET_KEY_BASE="$(mix phx.gen.secret)"
else
  SECRET_KEY_BASE="${SECRET_KEY}"
fi

DATABASE_URL="ecto://${DB_USER}:${DB_PASS}@${DB_HOST}/${DB_NAME}"

export SECRET_KEY_BASE=$SECRET_KEY_BASE
export DATABASE_URL=$DATABASE_URL

docker build -t phoenix_react -f release.Dockerfile ./
docker run --env SECRET_KEY_BASE=$SECRET_KEY_BASE --env DATABASE_URL=$DATABASE_URL --net=host -d phoenix_react:latest
