# dw-clickhouse

## Installation

Run the install script:

```shell
./scripts/install.sh
```

## Optional extras

### DBeaver

GUI client for ClickHouse and other databases. To install, run:

```shell
curl https://dbeaver.io/debs/dbeaver.gpg.key | sudo apt-key add -
echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
sudo apt update
sudo apt install dbeaver-ce
```

See the docs for [creating a connection](https://github.com/dbeaver/dbeaver/wiki/Create-Connection).

### Aliases

Add aliases for frequently used commands to `~/.bash_aliases`:

```shell
# Start ClickHouse
alias ach="cd /path/to/dw-clickhouse && docker compose up -d"

# Stop ClickHouse
alias sch="cd /path/to/dw-clickhouse && docker compose down"
```

Set `/path/to/` to the location of the repository on your machine. If you prefer to run the containers in the foreground, then omit the `-d` option.

## Uninstall

To delete all the data and Docker images, run:

```shell
./scripts/uninstall.sh
```

## Usage

Start the ClickHouse container in detached mode:

```shell
docker compose up -d
```

If you prefer to run the containers in the foreground, then omit the `-d` option.

## Networking

The following ports are exposed:

| Service            | Port  | Protocol              |
|--------------------|-------|-----------------------|
| clickhouse         | 29000 | HTTP                  |
| clickhouse         | 29001 | Native/TCP            |
| clickhouse         | 29002 | Postgres emulation    |

The configuration is loaded from `./.env` during startup. The default values are in `./template_env/docker-compose.env`.

## License

Copyright (c) 2023 Hein Bekker. Licensed under the GNU Affero General Public License, version 3.
