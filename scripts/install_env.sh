#!/bin/bash
set -e

scripts_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root_dir="${scripts_dir}/.."

source "${scripts_dir}/variables.sh"
source "${scripts_dir}/functions.sh"

function echo_help() {
    echo "Usage: $0 [--cache/--no-cache] [-f|--force] [--clickhouse_username <value>] [--clickhouse_password <value>] [--clickhouse_database <value>]"
}

cd "${root_dir}"

template_env_dir="template_env"
env_dir=".env_files"
cache_file="${env_dir}/.cache.env"

declare -a variable_names=( \
    "clickhouse_username" \
    "clickhouse_password" \
    "clickhouse_database"
)

mkdir -p "${env_dir}"

# Load variables from cache created in previous execution
if [ -f "${cache_file}" ] && [[ ! "${@}" =~ "--no-cache" ]]; then
    source "${cache_file}"
fi

cache=true
force=false
quiet=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --cache)
            cache=true
            shift
            ;;
        --no-cache)
            cache=false
            shift
            ;;
        -f|--force)
            force=true
            shift
            ;;
        --quiet)
            quiet=true
            shift
            ;;
        --help)
            echo_help
            exit 0
            ;;
        --clickhouse_username)
            clickhouse_username=$2
            shift 2
            ;;
        --clickhouse_password)
            clickhouse_password=$2
            shift 2
            ;;
        --clickhouse_database)
            clickhouse_database=$2
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            echo_help
            exit 1
            ;;
    esac
done

# Check whether the required values have been given
is_complete=true
for name in "${variable_names[@]}"; do
    if [ -z "${!name}" ]; then
        is_complete=false
    fi
done

# Prompt the user to give the missing values
if [ "$is_complete" == false ]; then
    echo "Please provide the following information:"

    for name in "${variable_names[@]}"; do
        if [ -z "${!name}" ]; then
            read -p "${name}: " "$name"
        fi
    done
fi

# Save variables to be used as defaults in next execution of this script
> "${cache_file}"
for name in "${variable_names[@]}"; do
    value="${!name}"
    echo "${name}=\"${value}\"" >> "${cache_file}"
done

# Render .env files
templates=(
    ${template_env_dir}/docker-compose.env       .env
    ${template_env_dir}/clickhouse.env           ${env_dir}/clickhouse.env
)

for ((i = 1; i < ${#templates[@]}; i+=2)); do
    template_file="${templates[i-1]}"
    output_file="${templates[i]}"

    if [ -f "${output_file}" ] && [ "$force" == false ]; then
        if [ "$quiet" == false ]; then
            echo "Skipped ${template_file} because ${output_file} exists"
        fi
    else
        render_template . "${template_file}" \
            "clickhouse_username=${clickhouse_username}" \
            "clickhouse_password=${clickhouse_password}" \
            "clickhouse_database=${clickhouse_database}" \
            > "${output_file}"

        if [ -f "${output_file}" ]; then
            if [ "$quiet" == false ]; then
                echo "${tput_green}Created ${output_file}${tput_reset}"
            fi
        fi
    fi
done
