#!/bin/bash
set -e

scripts_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root_dir="${scripts_dir}/.."

source "${scripts_dir}/variables.sh"
source "${scripts_dir}/functions.sh"

cd "${root_dir}"

# Create .env files
./scripts/install_env.sh $@

services=$(yq_cmd -o=csv '.services | keys' docker-compose.yml | tr ", " " ")

# Pull Docker images
cmd="docker compose pull ${services}"
$cmd

# Build Docker images
cmd="docker compose build ${services} --build-arg DOCKER_UID=$(id -u) --build-arg DOCKER_GID=$(id -g)"
$cmd

echo "${tput_green}Done!${tput_reset}"
