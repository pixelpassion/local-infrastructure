[![pixelpassion.io](https://img.shields.io/badge/made%20by-pixelpassion.io-blue.svg)](https://www.pixelpassion.io/)

# `🦑 Local development`

The repository provides Docker containers and tools to work on several projects. The images and tools are optimized for local usage and meant to stay around to work with several projects at the same time.

## Setup

Copy the .env example and add values (the Slack Webhook is not required)

```
cp .env.example .env
nano .env
```

Start the Postgres + Redis containers:

```
make up
```

You can build again with `make up-build`.

When you are done with your work, you can call `make down`. 

## Postgres database

To use Postgres in any local project, you must create a database.

```
./bin/reset_db.sh <DATABASE_NAME>
```

- It will create (or recreate) a database with a user of the same name and passwort `secret``
- You can then use DATABASE_URL=postgresql://test:secret@postgres/test

More commands:
- `db-logs` - Shows the Postgres logs (WIP)
- `db-reset` - Resets a database
- `db-export` - Exports a database
- `db-shell` - Open the `psql` shell to the database

## Redis cache

By default you can use `redis://@localhost:6379`. 

As Redis is shared with several projects, make sure to use different databases for each project by adding a number, e.g. `redis://@localhost:6379/2`

Commands:
- `redis-logs` - Shows the Redis logs (WIP)
- `redis-mon` - Redis Monitor for Default Cache
- `redis-reset-cache` - EReset Redis cache


## Docker helpers

### Cleanup of containers

```
make docker-clean
```

- It will DELETE all containers + images of the project defined as PROJECT_NAME in .env
- ATTENTION - this is untested and might delete ALL Docker stuff)


```
make docker-prune
```

Cleanup of unreferenced ressources

### Docker debugging

Get an Docker overview:

```
make docker-info
```

List the Docker events:

```
make docker-events
```


## Need help?

Copy debug informations into the Clip board, you can post it to us in Slack:

```
make debug
```

Start a tmate session and share the link on Slack. You need to press STRG+C to start the session.

```
make tmate
```

Get a list of all available Makefile commands:

```
make
```
