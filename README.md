# dw-clickhouse

## Installation

Run the install script:

```shell
./scripts/install.sh
```

## Optional extras

### DBeaver

Client for ClickHouse and other databases. To install, run:

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

## Database connections

The default settings for the ClickHouse server are:

```yaml
Host: localhost
Port: 29000
Username: analyst
Password: analyst
Database: analytics
```

Examples:

| Description                                       | Command                                                                                       |
|---------------------------------------------------|-----------------------------------------------------------------------------------------------|
| Use `clickhouse-client` installed on host machine | `clickhouse-client -h localhost -p 29001 -u analyst --password analyst -d analytics`          |
| Use `clickhouse-client` installed in container    | `docker compose exec clickhouse clickhouse-client -u analyst --password analyst -d analytics` |
| Use `psql` installed on host machine              | `psql -h localhost -p 29002 -U analyst -d analytics`                                          |

## Networking

Ports can optionally be exposed. The configuration is loaded from `./.env` during startup.

| Service            | Port  | Protocol              |
|--------------------|-------|-----------------------|
| `clickhouse`       | 29000 | HTTP                  |
| `clickhouse`       | 29001 | Native/TCP            |
| `clickhouse`       | 29002 | Postgres emulation    |

## Connecting to remote database via ODBC

The configuration is loaded from `./etc/odbc.ini` during startup.

```sql
select * from odbc('dsn=<DATA_SOURCE>', '<SCHEMA>', '<TABLE>');
```

`DATA_SOURCE`: Name of a section in `./etc/odbc.ini`

See [the ClickHouse docs](https://clickhouse.com/docs/en/sql-reference/table-functions/odbc) for more info.

## License

Copyright (c) 2023 Hein Bekker. Licensed under the GNU Affero General Public License, version 3.
