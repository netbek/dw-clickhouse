#!/bin/bash
set -e

if [ -z $1 ]; then
    echo "Usage: $0 MODE"
    exit 1
fi

mode=$1

if [ "$mode" == "dev" ]; then
    clickhouse-client \
        --host localhost \
        --port 9000 \
        --user "${CLICKHOUSE_USER}" \
        --password "${CLICKHOUSE_PASSWORD}" \
        --database "${CLICKHOUSE_DB}" \
        --query "create database if not exists testing;"

elif [ "$mode" == "ci" ]; then
    clickhouse-client \
        --host localhost \
        --port 9000 \
        --user "${CLICKHOUSE_USER}" \
        --password "${CLICKHOUSE_PASSWORD}" \
        --database "${CLICKHOUSE_DB}" \
        --query "create database if not exists testing;"
fi
