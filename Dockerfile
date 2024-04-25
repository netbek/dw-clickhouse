FROM clickhouse/clickhouse-server:24.3.2.23

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    curl gnupg lsb-release unixodbc

RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list && \
    apt-get update --yes && \
    apt-get install --yes --no-install-recommends odbc-postgresql
