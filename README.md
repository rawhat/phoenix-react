# PhoenixReact

This is a fairly simple, but relatively complete "template" for a... `phoenix`
and `react` application.

It's using `phoenix` 1.6 ish, generated with `ecto` and `html`, but instead of
`webpack`, it's using `esbuild` with `croc`.  It supports `typescript`, and
does type-checking with `tsc`.

Everything is bundled with `docker-compose`, which also mounts `/srv/app/db`
for `postgresql`.  That way you can have a persitent database to work with.

To setup, you'll probably want to run

  - `docker-compose build`
  - `POSTGRES_PASSWORD=some_password_you_want docker-compose run api mix ecto.create`

where the password can be anything you want.  If it's not `postgres`, you'll
have to change the password in `config/dev.exs`.

Then you should be able to run `docker-compose up` and access the app at
`http://localhost:4000`.

## Dependencies
It's pretty much self-contained, and you could totally just run all `mix phx.*`
tasks inside the container.  It's volume-mounted, so changes will be reflected
in the host file system.  Kinda nice to have `elixir` installed locally though.
