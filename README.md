# PhoenixReact

This is a fairly simple, but relatively complete "template" for a... `phoenix`
and `react` application.

It's using `phoenix` 1.6 ish, generated with `ecto` and `html`, but instead of
`webpack`, it's using `esbuild` with `croc`. It supports `typescript`, and
does type-checking with `tsc`.

Everything is bundled with `docker-compose`, which also mounts `/srv/app/db`
for `postgresql`. That way you can have a persitent database to work with.

To setup, you'll probably want to run

- `docker-compose build`
- `POSTGRES_PASSWORD=some_password_you_want docker-compose run api mix ecto.create`

where the password can be anything you want. If it's not `postgres`, you'll
have to change the password in `config/dev.exs`.

Then you should be able to run `docker-compose up` and access the app at
`http://localhost:4000`.

## Reusing

Do a `git clone` of this repo, and then do a find and replace for
`phoenix_react` and `PhoenixReact` and replace that with the app name you
would like. I _think_ that should work.

There is also support for just building/watching/reloading the UI. The
`npm run serve` target in `assets/` will run a `reload` server on
`localhost:3000` of the simple `index.html` and `dist/` folder generated from
the JS/CSS watch commands.

## Dependencies

It's pretty much self-contained, and you could totally just run all `mix phx.*`
tasks inside the container. It's volume-mounted, so changes will be reflected
in the host file system. Kinda nice to have `elixir` installed locally though.

## Releases

This template has support for building a slim, production `docker` image from
the `elixir` source and UI assets. To do so, simply run the `releases.sh`:

```bash
# Or just generate the secret somewhere else...
SECRET_KEY_BASE=(mix phx.gen.secret) DB_HOST=host DB_USER=user DB_NAME=myapp ./releases.sh
```

It will prompt you for the database password. This will build the production
container and start it as a daemon. If you want this image pushed somewhere,
just remove the last line of `releases.sh`.
